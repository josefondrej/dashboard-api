class AddIpAndDescriptionToServer < ActiveRecord::Migration[5.1]
  def change
    add_column :servers, :ip, :string
    add_column :servers, :description, :string
  end
end
