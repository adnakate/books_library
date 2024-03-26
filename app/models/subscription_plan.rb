class SubscriptionPlan < ApplicationRecord
  has_many :subscriptions

  validates_presence_of :name, :category, :book_limit, :magazine_limit,
                        message: Proc.new { |record, data| "You must provide #{data[:attribute]}" }
  validates :book_limit, :magazine_limit, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
