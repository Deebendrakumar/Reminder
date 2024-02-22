class EventReminder
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :time, type: String # Consider using the Time type for real applications
  field :status, type: String
  field :is_pinned, type: Mongoid::Boolean, default: false
  field :description, type: String
  
  embedded_in :user_event

end  