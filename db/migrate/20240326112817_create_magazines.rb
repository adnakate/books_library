class CreateMagazines < ActiveRecord::Migration[6.0]
  def change
    create_table :magazines do |t|
      t.string :title
      t.string :publisher
      t.string :genre
      t.integer :quantity
      t.timestamps
    end
  end
end
