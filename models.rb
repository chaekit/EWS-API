require 'mongoid'

class Lab
  include Mongoid::Document
  embeds_many :notification_ticket

  field :labname, type: String
  field :machine_count, type: Integer
  field :inuse_count, type: Integer
end


class NotificationTicket
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :lab

  field :requested_size, type: Integer
  field :expires_at, type: Time
end
