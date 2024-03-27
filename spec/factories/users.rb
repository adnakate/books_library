FactoryBot.define do
  sequence :email do |n|
    charset = Array('A'..'Z') + Array('a'..'z') + Array(0..9)
    email = Array.new(16) { charset.sample }.join
    "#{email}@example.com"
  end
end

FactoryBot.define do
  factory :user, :class => 'User' do
    first_name 'Abhijit'
    last_name 'Nakate'
    date_of_birth '20/10/1995'
    email
  end
end