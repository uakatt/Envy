class CreateMelodieSnapshots < ActiveRecord::Migration
  def change
    create_table :melodie_snapshots do |t|
      t.integer :environment_id
      t.string :host
      t.text :system_information
      t.text :system_details
      t.datetime :taken_at

      t.timestamps
    end
  end
end
