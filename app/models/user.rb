class User < ApplicationRecord
  has_many :transactions
  has_many :subscriptions
  belongs_to :current_subscription, class_name: 'Subscription', optional: true

  validates_presence_of :first_name, :last_name, :email, :date_of_birth,
                        message: Proc.new { |record, data| "You must provide #{data[:attribute]}" }
  validates_uniqueness_of :email, message: INVALID_EMAIL
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP, message: INVALID_EMAIL
end
