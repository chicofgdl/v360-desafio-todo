class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :list, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.boolean :done, null: false, default: false
      t.datetime :due_at
      t.integer :position, null: false, default: 1

      t.timestamps
    end

    add_index :tasks, [ :list_id, :position ]
    add_index :tasks, [ :list_id, :title ], unique: true
    add_index :tasks, [ :list_id, :done ]
  end
end
