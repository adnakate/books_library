class User < ApplicationRecord
  has_many :transactions
  has_many :subscriptions
  belongs_to :current_subscription, class_name: 'Subscription', optional: true

  validates_presence_of :first_name, :last_name, :email, :date_of_birth,
                        message: Proc.new { |record, data| "You must provide #{data[:attribute]}" }
  validates_uniqueness_of :email, message: INVALID_EMAIL
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP, message: INVALID_EMAIL

  def age
    today = Date.today
    dob = date_of_birth
    age = today.year - dob.year
    age -= 1 if today.month < dob.month || (today.month == dob.month && today.day < dob.day)
    age
  end

  def can_order_item?(item)
    return [false, USER_MUST_SUBSCRIBE] if !current_subscription.present?
    return [false, SHOULD_BE_ADULT] if age < 18 && item.genre == 'crime'
    return [false, EXCEEDED_MONTHLY_TRANSACTIONS] if total_transactions >= 10
    
    case current_subscription.subscription_plan.category
    when "silver"
      return can_order_silver_plan?(item)
    when "gold"
      return can_order_gold_plan?(item)
    when "platinum"
      return can_order_platinum_plan?(item)
    end
  end

  def total_transactions
    start_date = Date.today.beginning_of_month
    end_date = Date.today.end_of_month
    transactions.where('created_at > ? AND created_at < ?', start_date, end_date).count
  end

  def borrowed_books
    transactions.where.not(book_id: nil).where(returned_at: nil).count
  end

  def borrowed_magazines
    transactions.where.not(magazine_id: nil).where(returned_at: nil).count
  end

  def create_transaction(item)
    if item.is_a?(Book)
      transaction = transactions.create!(book: item, borrowed_at: Time.now)
    else
      transaction = transactions.create!(magazine: item, borrowed_at: Time.now)
    end
    transaction
  end

  private

  def can_order_silver_plan?(item)
    if item.is_a?(Magazine)
      [false, SILVER_PLAN_NO_MAGAZINE]
    elsif borrowed_books >= 2
      [false, SILVER_PLAN_TWO_BOOKS_ONLY]
    else
      [true, EMPTY_STRING]
    end 
  end

  def can_order_gold_plan?(item)
    if borrowed_books >= 3 && borrowed_magazines >= 1
      [false, GOLD_PLAN_THREE_BOOKS_ONE_MAGAZINE]
    elsif borrowed_books >= 3 && item.is_a?(Book) 
      [false, GOLD_PLAN_THREE_BOOKS]
    elsif borrowed_magazines >= 1 && item.is_a?(Magazine)
      [false, GOLD_PLAN_ONE_MAGAZINE]
    else
      [true, EMPTY_STRING]
    end
  end

  def can_order_platinum_plan?(item)
    if borrowed_books >= 4 && borrowed_magazines >= 2
      [false, PLATINUM_PLAN_FOUR_BOOKS_TWO_MAGAZINES]
    elsif borrowed_books >= 4 && item.is_a?(Book) 
      [false, PLATINUM_PLAN_FOUR_BOOKS]
    elsif borrowed_magazines >= 2 && item.is_a?(Magazine)
      [false, PLATINUM_PLAN_TWO_MAGAZINES]
    else
      [true, EMPTY_STRING]
    end
  end
end
