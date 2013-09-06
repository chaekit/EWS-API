require 'mongoid'
require 'apns'

class Lab
  include Mongoid::Document
  store_in collection: "labs"
  embeds_many :notification_tickets

  field :labname, type: String
  field :machinecount, type: Integer
  field :inusecount, type: Integer


  def process_tickets
    index = 0
    while notification_tickets.count > index
      ticket = notification_tickets.at(index)
      index += 1 unless ticket.process == :ticket_deleted
    end
  end

  def open_lab_size
    machinecount - inusecount
  end
end


class NotificationTicket
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "labs"
  embedded_in :lab

  field :requested_size, type: Integer
  field :expires_at, type: Time
  field :device_token, type: String

  def message_for_expired
    "#{lab.labname} is still busy!"    
  end

  def message_for_open
    "#{lab.labname} now has #{requested_size}+ open stations"
  end

  def ticket_status
    if requested_size < lab.open_lab_size
      :lab_open
    elsif expires_at < Time.now
      :ticket_expired 
    else
      :lab_busy
    end
  end

  def process
    case ticket_status
    when :lab_open 
      APNS.send_notification(device_token, message_for_open)
      self.delete
      return :ticket_deleted
    when :ticket_expired
      APNS.send_notification(device_token, message_for_expired)
      self.delete
      return :ticket_deleted
    else
      puts 'wtf'
    end
  end
end
