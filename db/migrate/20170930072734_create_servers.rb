class CreateServers < ActiveRecord::Migration[5.1]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :url
      t.timestamps
    end
  end
end
