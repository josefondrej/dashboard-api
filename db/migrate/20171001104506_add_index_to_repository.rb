class AddIndexToRepository < ActiveRecord::Migration[5.1]
  def change
    add_index :repositories, :url, unique: true
  end
end
