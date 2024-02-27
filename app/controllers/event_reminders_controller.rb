class EventRemindersController < ApplicationController

    before_action :validate_user
    before_action :getting, except: [:create, :search]

    def create
        @user_event = @user.user_events.find_by(id: params[:user_event_id])
        @reminder = @user_event.event_reminders.create!(user_params)
        render json: {message: 'Reminder Created Successfully'}, status: :ok
    end

    def show
        render json: {reminder_name: @reminder_detail.reminder_name, description: @reminder_detail.description}, status: :ok
    end

    def update
        @reminder_detail.update!(reminder_name: params[:reminder_name]) if params[:reminder_name].present?
        @reminder_detail.update!(time: params[:time]) if params[:time].present?
        @reminder_detail.update!(status: params[:status]) if params[:status].present?
        @reminder_detail.update!(is_pinned: params[:is_pinned]) if params[:is_pinned].present?
        @reminder_detail.update!(description: params[:description]) if params[:description].present?
        
        render json: {message: 'Updated Successful'}, status: :ok 
    end

    def destroy
        @reminder_detail.update!(status: params[:status])
    end

    def search
        @event = @user.user_events.find_by(id: params[:user_event_id])
        reminder_show = @event.event_reminders
        reminder_show = reminder_show.where(:reminder_name => params[:reminder_name]) if params[:reminder_name].present?
        reminder_show = reminder_show.where(:time.gte => params[:start_time]) if params[:start_time].present?
        reminder_show = reminder_show.where(:time.lte => params[:end_time]) if params[:end_time].present?
        binding.pry
        render json: reminder_show
    end

    private
    def user_params
        params.permit(:reminder_name, :time, :status, :is_pinned, :description)
    end

    def getting
        @user_event = @user.user_events.find_by(id: params[:user_event_id])
        @reminder_detail = @user_event.event_reminders.find_by(id: params[:id])
    end
end



