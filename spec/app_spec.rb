require_relative './spec_helper'
require_relative '../app'

describe "App" do
  let(:app) { Sinatra::Application }
  include Rack::Test::Methods


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

    describe ":post/ticket/create" do
      before do
        attributes = FactoryGirl.attributes_for(:lab)
        Lab.where(labname: attributes["labname"]).
          stub(last: FactoryGirl.create(:lab))
        
        post '/ticket/create',  "ticket" => { "requested_size" => 5, "labname" => "DCL 416", 
                                        "device_token" => "abcdef", "expires_at" => 123456} 
      end
      
      it "'s content type should be in json" do
        last_response.headers["Content-Type"].should == "application/json;charset=utf-8"
      end

      it "'s params should be hash with root key being ticket" do
        last_request.params.has_key?("ticket").should be_true
      end

      it "should add the ticket to the corresponding Lab" do
        Lab.where(labname: "DCL 416").
          last.notification_tickets.should_not be_nil
      end

      after(:all) do
        @lab = nil
      end
    end

    describe ":post/ticket/delete" do
      before do
        @lab = FactoryGirl.create(:lab)        
        @lab.update_attributes(notification_tickets: [FactoryGirl.create(:ticket_with_closed_lab)])
        Lab.where(labname: "DCL 416").
          stub(last: @lab)
       
        post '/ticket/delete',  "ticket" => {  
                                  "labname" => "DCL 416",
                                  "device_token" => "abcdefghijklmnopqrstuvwxyz", 
                                }
      end
      
      it "should delete the corresponding ticket" do
        Lab.where(labname: "DCL 416").last.notification_tickets.should be_empty
      end
    end
  end
end
