FactoryBot.define do
  factory :subscription_plan do
    name 'Gold'
    category 'gold'
    book_limit 3
    magazine_limit 1
  end
end
