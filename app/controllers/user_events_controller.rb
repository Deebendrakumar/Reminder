class UserEventsController < ApplicationController

    # before_action :get_user, only:[index]

    before_action :validate_user, except: []
    def get_user
      binding.pry
      user = User.find_by(email: params[:email])
    end

    def create
      binding.pry
      @event = @user.user_events.create!(user_event_params)
      render json: {message: 'Created Successfully'}, status: 200
    end

    def index
      # @user.user_events
      # render json: {name: @user.name, email: @user.email, mobile_number: @user.mobile_number, date: @event.date}, status: :ok
      render json: { event: @user.user_events[6].title}
    end

    def update

    end

    def delete
    end

    def search
    end

    private
    def user_event_params
      params.permit(:title, :date, :is_pinned, :status)
    end
    
end
