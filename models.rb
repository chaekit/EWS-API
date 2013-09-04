require 'mongoid'

class Lab
  include Mongoid::Document
  embeds_many :notification_ticket

  field :labname, type: String
  field :machinecount, type: Integer
  field :inusecount, type: Integer
end


class NotificationTicket
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :lab

  field :requested_size, type: Integer
  field :expires_at, type: Time
  field :device_udid, type: String
end
