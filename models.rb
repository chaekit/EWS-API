require 'mongoid'

class Lab
  include Mongoid::Document
  store_in collection: "labs"
  embeds_many :notification_tickets

  field :labname, type: String
  field :machinecount, type: Integer
  field :inusecount, type: Integer
end


class NotificationTicket
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "labs"
  embedded_in :lab

  field :requested_size, type: Integer
  field :expires_at, type: Time
  field :device_udid, type: String

  def message_for_expired
    "#{lab.labname} is still busy!"    
  end

  def message_for_open
    "#{lab.labname} now has #{requested_size}+ open stations"
  end
end
