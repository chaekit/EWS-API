FactoryGirl.define do
  factory :lab do
    labname       "DCL 416"

    trait :open_for_ten do
      machinecount  15
      inusecount    26
    end

    trait :open_for_five do
      machinecount 20
      inusecount   26
    end

    factory :open_for_five_lab, traits: [:open_for_five]
    factory :open_for_ten_lab, traits: [:open_for_ten]
  end

  factory :notification_ticket do
    requested_size 15
    expires_at 3.hours.from_now
  end
end
