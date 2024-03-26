class DummyData
  def create_subscription_plans
    puts '------creating subscription plans-------'
    SubscriptionPlan.create!(name: 'Silver', category: 'silver', book_limit: 2, magazine_limit: 0)
    SubscriptionPlan.create!(name: 'Gold', category: 'gold', book_limit: 3, magazine_limit: 1)
    SubscriptionPlan.create!(name: 'Platinum', category: 'platinum', book_limit: 4, magazine_limit: 2)
  end

  def create_users
    puts '------creating users-------'
    User.create!(first_name: 'Abhijit', last_name: 'Nakate', email: 'abhijit@gmail.com', date_of_birth: '20/10/1995')
    User.create!(first_name: 'Akshay', last_name: 'Koshti', email: 'akshay@gmail.com', date_of_birth: '24/02/1995')
    User.create!(first_name: 'Akash', last_name: 'Bais', email: 'akash@gmail.com', date_of_birth: '30/10/1995')
    User.create!(first_name: 'Rupesh', last_name: 'Pund', email: 'rupesh@gmail.com', date_of_birth: '10/03/2008')
    User.create!(first_name: 'Abhsihek', last_name: 'Ushekar', email: 'abhishek@gmail.com', date_of_birth: '24/05/2007')
  end

  def create_subscriptions
    puts '------creating user subscriptions-------'
    subscription_plan_ids = SubscriptionPlan.ids
    User.all.each do |user|
      subscription = user.subscriptions.create!(subscription_plan_id: subscription_plan_ids.sample,
                                                start_at: Time.zone.now,
                                                end_at: Time.zone.now + 30.days)
      user.update!(current_subscription_id: subscription.id)
    end
  end

  def create_books
    puts '------creating books-------'
    Book.create!(title: 'Physics', author: 'James Bond', genre: 'science', quantity: 10)
    Book.create!(title: 'Myth', author: 'Anurag Thakur', genre: 'mythology', quantity: 3)
    Book.create!(title: 'The scene', author: 'Jay Prakash', genre: 'crime', quantity: 5)
    Book.create!(title: 'Fun', author: 'Charlie', genre: 'comedy', quantity: 7)
    Book.create!(title: 'Chemistry', author: 'James Bond', genre: 'science', quantity: 8)
    Book.create!(title: 'Island', author: 'Mike Yes', genre: 'horror', quantity: 4)
  end

  def create_magazines
    puts '------creating magazines-------'
    Magazine.create!(title: 'Forbes India', publisher: 'Forbes', genre: 'business', quantity: 5)
    Magazine.create!(title: 'Auto India', publisher: 'Autocar', genre: 'Automobile', quantity: 15)
    Magazine.create!(title: 'Champak', publisher: 'Champak', genre: 'comedy', quantity: 7)
    Magazine.create!(title: 'Chitralekha', publisher: 'Rajashri', genre: 'comedy', quantity: 7)
    Magazine.create!(title: 'Crime Week', publisher: 'Police', genre: 'crime', quantity: 3)
  end
end