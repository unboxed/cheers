FactoryGirl.define do
  factory :cheer do
    sender "sender"
    association :shoutout, factory: :shoutouts
  end
end
