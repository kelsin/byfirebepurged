class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :permissioned, :polymorphic => true, :null => false
      t.string :level, :null => false
      t.string :key, :null => false
      t.timestamps
    end
  end
end
