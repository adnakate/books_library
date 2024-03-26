class User < ApplicationRecord
  has_many :transactions
  has_many :subscriptions
  belongs_to :current_subscription, class_name: 'Subscription', optional: true
end
