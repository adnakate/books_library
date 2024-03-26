class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :subscription_plan, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
    end
  end
end
