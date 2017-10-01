class AddUrlToDeployment < ActiveRecord::Migration[5.1]
  def change
    add_column :deployments, :url, :string
  end
end
