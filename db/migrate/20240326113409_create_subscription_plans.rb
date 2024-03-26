class CreateSubscriptionPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.string :category
      t.integer :book_limit
      t.integer :magazine_limit
      t.timestamps
    end
  end
end
