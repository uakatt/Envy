class CreateEnvestigations < ActiveRecord::Migration
  def change
    create_table :envestigations do |t|
      t.integer  :environment_id
      t.datetime :time
      t.string   :title
      t.text     :text
      t.text     :exception

      t.timestamps
    end
  end
end
