class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.references :magazine, foreign_key: true
      t.datetime :borrowed_at
      t.datetime :returned_at
      t.timestamps
    end
  end
end
