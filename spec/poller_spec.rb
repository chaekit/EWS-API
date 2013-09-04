require_relative './spec_helper'
require_relative '../app'
require_relative '../poller'

describe Poller do
  before do
    stub_request(:get, Poller::EWS_URL).
      to_return(:body => JSONFactory.typical_usage)
  end

  context "methods" do
    before(:each) do
      Poller.poll_usage
    end

    describe "#poll_usage" do
      it "should poll the usage form EWS_URL" do
        a_request(:get, Poller::EWS_URL).should have_been_made 
      end
    end

    describe "#parsed_json_data" do
      it "'s return value should be symbols" do
        Poller.stub(raw_json: JSONFactory.typical_usage) 
        return_array = Poller.parsed_json_data
        return_array.each { |hash| hash.keys.first.class.should == Symbol }
      end
    end
  end
end
