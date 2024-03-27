FactoryBot.define do
  factory :transaction do
    association :user
    association :book
    association :magazine
    borrowed_at Time.zone.now - 1.days
    returned_at nil
  end
end
