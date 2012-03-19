class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.string :code
      t.string :name
      t.string :url
      t.string :app

      t.timestamps
    end
  end
end
