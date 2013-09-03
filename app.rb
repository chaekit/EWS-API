require 'sinatra'
require 'sinatra/json'
require 'httparty'

EWS_LABS = {
  "DCL L416"=> {"strlabname"=> "DCL L416","inusecount"=> 0,"machinecount"=> 26},
  "DCL L440"=> {"strlabname"=> "DCL L440","inusecount"=> 0,"machinecount"=> 30},
  "DCL L520"=> {"strlabname"=> "DCL L520","inusecount"=> 0,"machinecount"=> 41},
  "EH 406B1"=> {"strlabname"=> "EH 406B1","inusecount"=> 0,"machinecount"=> 40},
  "EH 406B8"=> {"strlabname"=> "EH 406B8","inusecount"=> 0,"machinecount"=> 40},
  "EVRT 252"=> {"strlabname"=> "EVRT 252","inusecount"=> 0,"machinecount"=> 39},
  "GELIB 057"=> {"strlabname"=> "GELIB 057","inusecount"=> 0,"machinecount"=> 40},
  "GELIB 4th"=> {"strlabname"=> "GELIB 4th","inusecount"=> 0,"machinecount"=> 39},
  "MEL 1001"=>{"strlabname"=> "MEL 1001","inusecount"=> 0,"machinecount"=> 25},
  "MEL 1009"=> {"strlabname"=> "MEL 1009","inusecount"=> 0,"machinecount"=> 40},
  "SIEBL 0218"=> {"strlabname"=> "SIEBL 0218","inusecount"=> 0,"machinecount"=> 36},
  "SIEBL 0220"=> {"strlabname"=> "SIEBL 0220","inusecount"=> 0,"machinecount"=> 21},
  "SIEBL 0222"=> {"strlabname"=> "SIEBL 0222","inusecount"=> 0,"machinecount"=> 36}
}

get '/labusage' do
  json :data => usage_hash
end

public

def parse_data
  parsed_json = JSON.parse(HTTParty.get(ews_url))["data"]
  parsed_json.each do |lab|
    lab_name = lab["strlabname"]
    usage_hash[lab_name]["inusecount"] = lab["inusecount"]
    usage_hash[lab_name]["machinecount"] = lab["machinecount"]
  end  
end

def ews_url
  @ews_url ||= "https://my.engr.illinois.edu/labtrack/util_data_json.asp?callback=" 
end

def usage_hash
  @usage_hash = EWS_LABS
end


