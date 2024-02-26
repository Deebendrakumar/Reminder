class EventDate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, type: Date # You might want to use the Date type and perform conversion

  embedded_in :user 
  embeds_many :user_events

  accepts_nested_attributes_for :user_events
end
