class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.integer :envestigation_id
      t.datetime :time
      t.string :title

      t.timestamps
    end
  end
end
