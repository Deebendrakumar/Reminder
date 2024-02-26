class UserEventsController < ApplicationController

    before_action :set_event_date

    before_action :validate_user, except: []

    def create
    end

    def show
    end

    def update
    end

    def delete
    end

    def search
    end

    
    private
  
    def set_event_date
      @event_date = EventDate.find(params[:event_date_id])
    end
    
end
