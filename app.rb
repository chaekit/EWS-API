require 'sinatra'
require 'sinatra/json'
require 'httparty'
require 'mongoid'
require_relative './models'

set :protection, :except => [:json_csrf]

Mongoid.load!('./mongoid.yml', ENV['MONGO_ENV'])

get '/labusage' do
  json :data => Lab.all
end

post '/ticket' do
  puts params
  ticket_param = params["ticket"]
  lab = Lab.where(labname: ticket_param["labname"]).last
  expires_at_epoch = ticket_param["expires_at"]
  device_token = ticket_param["device_token"]
  
  ticket = NotificationTicket.create({ requested_size: ticket_param["requested_size"],
                             expires_at: Time.at(expires_at_epoch),
                             device_token: device_token,
                             lab: lab})
  json 200
end
