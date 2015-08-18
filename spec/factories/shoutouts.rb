FactoryGirl.define do
  factory :shoutout do
    transient do
      tag_list 'london'
    end

    sender "Jeff"
    message "thanks to @Bob"
    recipients ["Bob"]
    before(:create) do |shoutout, evaluator|
      shoutout.tag_list = evaluator.tag_list
    end
  end
end
