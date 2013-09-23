require 'sinatra'
require 'sinatra/json'
require 'httparty'
require 'mongoid'
require_relative './models'

set :protection, :except => [:json_csrf]
set :json_encoder, :to_json

Mongoid.load!('./mongoid.yml', ENV['MONGO_ENV'])

get '/labusage' do
  json :data => Lab.all
end

post '/ticket/create' do
  # puts params
  ticket_param = params["ticket"]
  lab = Lab.where(labname: ticket_param["labname"]).last
  expires_at_epoch = Integer(ticket_param["expires_at"])
  device_token = ticket_param["device_token"]
  requested_size = Integer(ticket_param["requested_size"])
  
  ticket = NotificationTicket.create({ requested_size: requested_size,
                             expires_at: Time.at(expires_at_epoch),
                             device_token: device_token,
                             lab: lab})
  json 200
end

post '/ticket/delete' do
  ticket_param = params["ticket"]
  labname = ticket_param["labname"]
  device_token = ticket_param["device_token"]

  lab = Lab.where(labname: labname).last
  ticket = lab.notification_tickets.select { |t| t.device_token == device_token }.first
  ticket.destroy
end
