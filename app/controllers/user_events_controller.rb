class UserEventsController < ApplicationController

  before_action :validate_user
  before_action :get_user, only:[:update, :destroy]
  
    def get_user
      @user_event = @user.user_events.find_by(id: params[:id])
    end


    def create
      @event = @user.user_events.create!(user_event_params)
      render json: {message: 'Created Successfully'}, status: 200
    end

    def index
      render json: { user_event_titles: @user.user_events.pluck(:title, :date)}
    end

    def update
      @user_event.update(title: params[:title]) if params[:title].present?
      @user_event.update(date: params[:date]) if params[:date].present?
      @user_event.update(is_pinned: params[:is_pinned]) if params[:is_pinned].present?
      @user_event.update(status: params[:status]) if params[:status].present?

        render json: {message: 'updated successfully'}, status: :ok

    end

      def destroy
        if @user_event.update(status: params[:status])
          render json: {message: 'Success'}
        else
          render json: {message: 'failed'}
        end
      end
      
    def search
      events_within_range = @user.user_events
      events_within_range = events_within_range.where(:date.gte => params[:start_date]) if params[:start_date].present?
      events_within_range = events_within_range.where(:date.lte => params[:end_date]) if params[:end_date].present?
      events_within_range = events_within_range.where(:title => params[:title]) if params[:title].present?
      events_within_range = events_within_range.where(:is_pinned => params[:is_pinned]) if params[:is_pinned].present?
      events_within_range = events_within_range.where(:status => params[:status]) if params[:status].present?
      render json: events_within_range
    end

    private
    def user_event_params
      params.permit(:title, :date, :is_pinned, :status) 
    end
    
end
