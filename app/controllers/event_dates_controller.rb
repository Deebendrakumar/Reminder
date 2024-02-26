class EventDatesController < ApplicationController

    before_action :validate_user, except: []
    before_action :set_user, except: []

    def create
        event_date = User.EventDate.create(user_params)
    end

    def show
        event_date = user.event_dates
    end

    def update

    end

    def delete
    end

    def search
    end

    private
    def user_params
        params.permit(:value)
    end

    def set_user
        user = User.find_by(user_id)
    end
end
