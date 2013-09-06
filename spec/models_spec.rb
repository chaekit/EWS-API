require_relative './spec_helper'
require_relative '../models'

describe Lab do
  context "valid properties" do
    it { should respond_to(:labname) }
    it { should respond_to(:machinecount) }
    it { should respond_to(:inusecount) }
    it { should respond_to(:notification_tickets) }
  end

  context "embedded documents" do
    it { should embed_many(:notification_tickets) }
  end

  context "instance methods" do
    describe "#process_tickets" do
      before do

      end
      context "when it is open" do
        let(:open_lab) { FactoryGirl.create(:open_for_ten) }

        xit "should delete all the matching tickets" do 
        end
        xit "should send notifications with valid message" do
        end
      end

      context "when ticket is expired" do
        let(:open_lab) { FactoryGirl.create(:open_for_five) }

        xit "should delete the ticket" do
        end

        xit "should send notification with valid message" do
        end
      end
    end
  end
end

describe NotificationTicket do

  let(:ticket) { FactoryGirl.build(:notification_ticket) }
  
  context "valid properties" do
    it { should respond_to(:requested_size) }
    it { should respond_to(:expires_at) }
    it { should respond_to(:created_at) }
    it { should respond_to(:device_udid) }
  end

  context "instance methods" do
    describe "message_for_open"do
      it "should include the lab name" do
        include_labname = ticket.message_for_open.include?(ticket.lab.labname)
        include_labname.should be_true
      end

      it "should include the requested_size" do
        include_size = ticket.message_for_open.include?(ticket.requested_size.to_s)
        include_size.should be_true
      end
    end

    describe "message_for_expired" do
      it "should include the lab name" do
        include_labname = ticket.message_for_expired.include?(ticket.lab.labname)
        include_labname.should be_true
      end
    end
  end
end
