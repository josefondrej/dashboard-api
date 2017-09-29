class CreateRepositories < ActiveRecord::Migration[5.1]
  def change
    create_table :repositories do |t|
      t.string :url
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
