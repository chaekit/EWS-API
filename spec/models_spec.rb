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
end

describe NotificationTicket do
  context "valid properties" do
    it { should respond_to(:requested_size) }
    it { should respond_to(:expires_at) }
    it { should respond_to(:created_at) }
    it { should respond_to(:device_udid) }
  end
end
