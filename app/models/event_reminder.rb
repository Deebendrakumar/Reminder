class EventReminder
  include Mongoid::Document
  include Mongoid::Timestamps

  field :reminder_name, type: String
  field :time, type: Time 
  field :status, type: String
  field :is_pinned, type: Mongoid::Boolean, default: false
  field :description, type: String
  
  embedded_in :user_event

end