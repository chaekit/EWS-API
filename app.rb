require 'sinatra'
require 'sinatra/json'
require 'httparty'
require 'mongoid'
require_relative './models'

Mongoid.load!('./mongoid.yml', :development)

get '/labusage' do
  json :data => Lab.all
end

post '/ticket' do
  ticket_param = params["ticket"]
  lab = Lab.where(labname: ticket_param["labname"]).last
  ticket = NotificationTicket.create({ requested_size: ticket_param["requested_size"],
                             expires_at: Time.now,
                             device_udid: ticket_param["device_udid"],
                             lab: lab})

  json 200
end
