class AddHostsToEnvironment < ActiveRecord::Migration
  def change
    add_column :environments, :hosts, :string
  end
end
