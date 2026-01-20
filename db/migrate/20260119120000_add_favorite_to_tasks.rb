class AddFavoriteToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :favorite, :boolean, null: false, default: false
    add_index :tasks, :favorite
  end
end
