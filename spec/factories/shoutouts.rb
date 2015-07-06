FactoryGirl.define do
  factory :shoutout do
    sender "Jeff"
    message "thanks to @Bob"
    recipients(["Bob"])
  end
end
