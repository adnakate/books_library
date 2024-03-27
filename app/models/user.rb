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
    return [false, "User must suscribe first"] if !current_subscription.present?
    return [false, "You must be above 18 years"] if age < 18 && item.genre == 'crime'
    return [false, "Exceeded monthly transaction limit"] if total_transactions >= 10
    
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
      [false, "Silver plan does not allow magazine"]
    elsif borrowed_books >= 2
      [false, "Silve plan allows only 2 books"]
    else
      [true, ""]
    end 
  end

  def can_order_gold_plan?(item)
    if borrowed_books >= 3 && borrowed_magazines >= 1
      [false, "Gold plan allows only 3 books and 1 magazine"]
    elsif borrowed_books >= 3 && item.is_a?(Book) 
      [false, "Gold plan allows only 3 books"]
    elsif borrowed_magazines >= 1 && item.is_a?(Magazine)
      [false, "Gold plan allows only 1 magazine"]
    else
      [true, ""]
    end
  end

  def can_order_platinum_plan?(item)
    if borrowed_books >= 4 && borrowed_magazines >= 2
      [false, "Platinum plan allows only 4 books and 2 magazines"]
    elsif borrowed_books >= 4 && item.is_a?(Book) 
      [false, "Platinum plan allows only 4 books"]
    elsif borrowed_magazines >= 2 && item.is_a?(Magazine)
      [false, "Platinum plan allows only 2 magazines"]
    else
      [true, ""]
    end
  end
end
