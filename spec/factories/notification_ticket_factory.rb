FactoryGirl.define do
  factory :notification_ticket do
    requested_size    5
    # expires_at        3.hours.from_now
    device_udid       'abcdefghijklmnopqrstuvwxyz'
    association       :lab, strategy: :build
  end
end
