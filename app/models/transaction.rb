class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :book, optional: true
  belongs_to :magazine, optional: true
end
