require_relative './spec_helper'
require_relative '../app'

describe "App" do
  include Rack::Test::Methods

  let(:app) { Sinatra::Application }

  context "endpoints" do
    describe ":get/labusage" do
      before do
        get '/labusage'
      end

      it "'s content type should be in json" do
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
      end

      it "'s body should be a hash with root key being 'data'" do
        JSON.parse(last_response.body)["data"].should be_a(Array)
      end
    end

    describe ":post/ticket" do
      before do
        post '/ticket',  "ticket" => { "requested_size" => 5 } 
      end
      
      it "'s content type should be in json" do
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
      end

      it "'s params should be hash with root key being ticket" do
        last_request.params.has_key?("ticket").should be_true
      end
      
    end
  end

  context "attributes" do
    describe "ews_url" do
      it "should have valid url" do
        app.ews_url.should == "https://my.engr.illinois.edu/labtrack/util_data_json.asp?callback=" 
      end
    end

    describe "usage_hash" do
      it "should not be nil after loading" do
        app.usage_hash.should_not be_nil
      end

      it "should have exactly 13 key/values" do
        app.usage_hash.length.should == 13
      end
    end
  end

  context "helpers" do
    before do
      stub_request(:get, app.ews_url).
        to_return(:body => JSONFactory.typical_usage)
    end

    describe "#parse_data" do
      before(:each) do
        app.parse_data
      end

      it "should make a call to the ews_url" do
        a_request(:get, app.ews_url).should have_been_made 
      end

      it "should poll from the server and update usage_hash" do
        stubbed_usage_json = JSONFactory.typical_usage
        expected_hash = JSON.parse(stubbed_usage_json)["data"]
        usage_hash = app.usage_hash

        expected_hash.each do |lab|
          lab_name = lab["strlabname"]
          usage_hash[lab_name]["inusecount"].should == lab["inusecount"]
          usage_hash[lab_name]["machinecount"].should == lab["machinecount"]
        end  

      end
    end
  end

end
