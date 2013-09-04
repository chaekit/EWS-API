require 'httparty'
require_relative './models'

Mongoid.load!('mongoid.yml', :development)

module Poller
  EWS_URL = "https://my.engr.illinois.edu/labtrack/util_data_json.asp?callback="

  class << self
    def poll_usage
      parsed_json_data.each do |lab|
        lab_name = lab[:strlabname]
        current_inusecount = lab[:inusecount] 
        current_machinecount = lab[:machinecount]
        Lab.where(labname: lab_name).
          update({ inusecount: current_inusecount, machinecount: current_machinecount })
      end  
    end

    def raw_json
      HTTParty.get(EWS_URL)
    end

    def parsed_json_data
      JSON.parse(raw_json, :symbolize_names => true)[:data]
    end
  end
end

