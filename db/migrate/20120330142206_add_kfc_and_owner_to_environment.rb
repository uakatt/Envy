class AddKfcAndOwnerToEnvironment < ActiveRecord::Migration
  def change
    add_column :environments, :kfc, :string
    add_column :environments, :owner, :string
  end
end
