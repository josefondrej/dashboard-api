class AddIpAndDescriptionToServer < ActiveRecord::Migration[5.1]
  def change
    add_column :servers, :ip, :string
    add_column :servers, :description, :string, default: 'no description'

    add_index :servers, :ip, unique: true
  end
end
