# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

# helper libraries
require 'webmock/rspec'
require 'rack/test'
require 'mongoid-rspec'
require 'factory_girl'

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.color_enabled = true
  config.include Mongoid::Matchers

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end


module JSONFactory
  class << self
    def typical_usage
     '{"data": [{"strlabname": "DCL L416","inusecount": 0,"machinecount": 26},
        {"strlabname": "DCL L440","inusecount": 1,"machinecount": 30},
        {"strlabname": "DCL L520","inusecount": 0,"machinecount": 41},
        {"strlabname": "EH 406B1","inusecount": 3,"machinecount": 40},
        {"strlabname": "EH 406B8","inusecount": 2,"machinecount": 40},
        {"strlabname": "EVRT 252","inusecount": 19,"machinecount": 39},
        {"strlabname": "GELIB 057","inusecount": 1,"machinecount": 40},
        {"strlabname": "GELIB 4th","inusecount": 2,"machinecount": 39},
        {"strlabname": "MEL 1001","inusecount": 0,"machinecount": 25},
        {"strlabname": "MEL 1009","inusecount": 0,"machinecount": 40},
        {"strlabname": "SIEBL 0218","inusecount": 13,"machinecount": 36},
        {"strlabname": "SIEBL 0220","inusecount": 15,"machinecount": 21},
        {"strlabname": "SIEBL 0222","inusecount": 17,"machinecount": 36}]}'
    end
  end
end
