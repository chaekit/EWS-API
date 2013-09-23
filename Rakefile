require_relative './poller'
require_relative './models'
require 'mongoid'
require 'apns'

Mongoid.load!("./mongoid.yml", ENV['MONGO_ENV'])

task :poll_usage do
  Poller.poll_usage
end

task :process_tickets => [:poll_usage] do
  Lab.process_all_tickets
end

task :insert_default_usage do
  Lab.create!([{"labname"=> "DCL L416","inusecount"=> 0,"machinecount"=> 26},
    {"labname"=> "DCL L440","inusecount"=> 1,"machinecount"=> 30},
    {"labname"=> "DCL L520","inusecount"=> 0,"machinecount"=> 41},
    {"labname"=> "EH 406B1","inusecount"=> 3,"machinecount"=> 40},
    {"labname"=> "EH 406B8","inusecount"=> 2,"machinecount"=> 40},
    {"labname"=> "EVRT 252","inusecount"=> 19,"machinecount"=> 39},
    {"labname"=> "GELIB 057","inusecount"=> 1,"machinecount"=> 40},
    {"labname"=> "GELIB 4th","inusecount"=> 2,"machinecount"=> 39},
    {"labname"=> "MEL 1001","inusecount"=> 0,"machinecount"=> 25},
    {"labname"=> "MEL 1009","inusecount"=> 0,"machinecount"=> 40},
    {"labname"=> "SIEBL 0218","inusecount"=> 13,"machinecount"=> 36},
    {"labname"=> "SIEBL 0220","inusecount"=> 15,"machinecount"=> 21},
    {"labname"=> "SIEBL 0222","inusecount"=> 17,"machinecount"=> 36}])
end

