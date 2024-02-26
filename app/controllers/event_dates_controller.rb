class EventDatesController < ApplicationController
    before_action :get_user
    def get_user
        user = User.find(user_id)
    end

    def create
        event_date = user.event_dates.create(event_date_params)
    end

    def show
        event_dates = user.event_dates
    end

    def update
        EventDate.where(user_id: user_id).update_all(event_date_params)
    end

    def delete
        EventDate.where(user_id: user_id).destroy_all
    end

    def search
        
    end

    private
    def event_date_params
      params.permit(:value)
    end

end