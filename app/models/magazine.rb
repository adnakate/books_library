class Magazine < ApplicationRecord
  has_many :transactions

  validates_presence_of :title, :publisher, :genre, :quantity,
                        message: Proc.new { |record, data| "You must provide #{data[:attribute]}" }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  paginates_per PER_PAGE

  def decrease_quantity
    update(quantity: quantity - 1)
  end

  def increase_quantity
    update(quantity: quantity + 1)
  end      
end
