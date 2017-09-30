class CreateDeployments < ActiveRecord::Migration[5.1]
  def change
    create_table :deployments do |t|
      t.integer :repository_id, null: false
      t.integer :server_id, null: false

      t.string :type

      t.timestamps
    end
  end
end
