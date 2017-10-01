class RemoveUrlFromServer < ActiveRecord::Migration[5.1]
  def change
    remove_column :servers, :url
  end
end
