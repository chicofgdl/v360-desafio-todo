class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :list, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.boolean :done
      t.datetime :due_at
      t.integer :position

      t.timestamps
    end
  end
end
