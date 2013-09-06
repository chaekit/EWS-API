FactoryGirl.define do
  factory :notification_ticket do
    requested_size    5
    device_token       'abcdefghijklmnopqrstuvwxyz'
    association       :lab, strategy: :build

    trait :not_expired do
      expires_at      Time.now + 100.0
    end

    trait :expired do
      expires_at      Time.now - 0.9
    end

    trait :with_open_lab do
      requested_size  5
      association     :lab, factory: :open_for_five_lab, strategy: :build
    end
    
    trait :with_closed_lab do
      requested_size  10
      association     :lab, factory: :open_for_five_lab, strategy: :build
    end

    factory :ticket_with_open_lab, traits: [:not_expired, :with_open_lab]
    factory :ticket_with_closed_lab, traits: [:not_expired, :with_closed_lab]
    factory :expired_ticket, traits: [:expired, :with_open_lab]
  end
end
