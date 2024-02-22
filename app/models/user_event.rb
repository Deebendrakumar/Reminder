class UserEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :status, type: String
  field :is_pinned, type: Mongoid::Boolean, default: false

  embedded_in :event_date
  embeds_many :event_reminders

  accepts_nested_attributes_for :event_reminders
end
