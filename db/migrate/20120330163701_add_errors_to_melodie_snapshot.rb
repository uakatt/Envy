class AddErrorsToMelodieSnapshot < ActiveRecord::Migration
  def change
    add_column :melodie_snapshots, :snapshot_errors, :text
  end
end
