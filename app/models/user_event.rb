class UserEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :date, type: Date
  field :status, type: String, default: "active"
  field :is_pinned, type: Mongoid::Boolean, default: false  
    
  embeds_many :event_reminders
  embedded_in :user

  accepts_nested_attributes_for :event_reminders
end
