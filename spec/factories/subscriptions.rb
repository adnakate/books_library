FactoryBot.define do
  factory :subscription do
    association :user
    association :subscription_plan
  end
end
