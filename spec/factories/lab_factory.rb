FactoryGirl.define do
  factory :lab do
    labname       "DCL 416"
    notification_tickets  Array.new

    trait :open_for_ten do
      machinecount  26
      inusecount    15
    end

    trait :open_for_five do
      machinecount 26
      inusecount   20
    end

    factory :open_for_five_lab, traits: [:open_for_five]
    factory :open_for_ten_lab, traits: [:open_for_ten]
  end
end
