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
  context "class methods" do
    describe ".process_all_tickets" do
      it "should query al Labs first" do
        Lab.stub(:each)   
        Lab.should_receive(:each).once
        Lab.process_all_tickets
      end
    end
  end

  context "instance methods" do
    describe "#process_tickets" do
      context "when it is open" do
        let(:open_lab) { FactoryGirl.create(:open_for_ten_lab) }

        before do
          open_lab.update(notification_tickets: 
                          (FactoryGirl.create_list(:ticket_with_open_lab, 3, lab: open_lab)))

          APNS.stub(:send_notification)
        end

        it "should delete all the matching tickets" do 
          open_lab.notification_tickets.count.should == 3
          open_lab.process_tickets
          open_lab.notification_tickets.count.should == 0
        end

        it "should send notifications with valid message" do
          APNS.should_receive(:send_notification).exactly(3).times
          open_lab.process_tickets
        end
      end

      context "when ticket is expired" do
        let(:open_lab) { FactoryGirl.create(:open_for_five_lab) }

        before do
          open_lab.update(notification_tickets: 
                          (FactoryGirl.create_list(:expired_ticket, 3, lab: open_lab)))

          APNS.stub(:send_notification)
        end

        it "should delete the ticket" do
          open_lab.notification_tickets.count.should == 3
          open_lab.process_tickets
          open_lab.notification_tickets.count.should == 0
        end

        it "should send notification with valid message" do
          APNS.should_receive(:send_notification).exactly(3).times
          open_lab.process_tickets
        end
      end
    end

    describe "#open_lab_size" do
      let(:lab) { FactoryGirl.create(:open_for_ten_lab) }
      it "should be the subtraction of machinecount and inusecount" do
        diff = lab.machinecount - lab.inusecount
        lab.open_lab_size.should == diff
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
    it { should respond_to(:device_token) }
  end

  context "instance methods" do
    describe "#message_for_open"do
      it "should include the lab name" do
        include_labname = ticket.message_for_open.include?(ticket.lab.labname)
        include_labname.should be_true
      end

      it "should include the requested_size" do
        include_size = ticket.message_for_open.include?(ticket.requested_size.to_s)
        include_size.should be_true
      end
    end

    describe "#message_for_expired" do
      it "should include the lab name" do
        include_labname = ticket.message_for_expired.include?(ticket.lab.labname)
        include_labname.should be_true
      end
    end

    describe "#ticket_status" do
      let(:lab) { FactoryGirl.build(:lab) }
      before do
        ticket.stub(lab:lab)
      end
   
      it "should return :lab_open when the lab is open" do
        ticket.stub(requested_size: 10)
        lab.stub({ machinecount: 20, inusecount: 9 })
        
        ticket.ticket_status.should == :lab_open
      end

      it "should return :ticket_expired when the ticket is expired" do
        ticket.stub(expires_at: Time.now - 0.9)
        lab.stub({ machinecount: 20, inusecount: 15 })
        
        ticket.ticket_status.should == :ticket_expired
      end

      it "should return :lab_busy when its neither expired nor open" do
        ticket.stub(expires_at: Time.now + 0.9)
        ticket.stub(requested_size: 10)
        lab.stub({ machinecount: 20, inusecount: 15 })
        
        ticket.ticket_status.should == :lab_busy
      end
    end
  end
end
