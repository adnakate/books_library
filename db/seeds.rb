def create_dummy_data
  puts '-------we are creating dummy data for you please wait-------'
  dummy_data = DummyData.new
  dummy_data.create_subscription_plans
  dummy_data.create_users
  dummy_data.create_subscriptions
  dummy_data.create_books
  dummy_data.create_magazines
end

create_dummy_data