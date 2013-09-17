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

post '/ticket' do
  #puts request.env["rack.input"].read
  puts params
  ticket_param = params["ticket"]
  puts ticket_param["labname"]
  puts ticket_param["expires_at"]
  puts ticket_param["device_token"]
  puts ticket_param["requested_size"]
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
