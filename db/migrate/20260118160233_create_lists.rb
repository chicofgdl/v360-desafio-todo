class CreateLists < ActiveRecord::Migration[8.1]
  def change
    create_table :lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :position, null: false, default: 1

      t.timestamps
    end

    add_index :lists, [:user_id, :position]
    add_index :lists, [:user_id, :title], unique: true
  end
end
