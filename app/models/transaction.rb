class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :book, optional: true
  belongs_to :magazine, optional: true

  after_create :decrease_quantity
  after_update :increase_quantity, if: :saved_change_to_returned_at?

  paginates_per 10

  def complete_transaction
    update(returned_at: Time.now)
  end

  private

  def decrease_quantity
    book.decrease_quantity if book_id.present?
    magazine.decrease_quantity if magazine_id.present?
  end

  def increase_quantity
    book.increase_quantity if book_id.present?
    magazine.increase_quantity if magazine_id.present?
  end
end
