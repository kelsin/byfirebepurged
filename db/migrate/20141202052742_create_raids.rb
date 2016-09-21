class CreateRaids < ActiveRecord::Migration[4.2]
  def change
    create_table :raids do |t|
      t.string :name, :null => false
      t.datetime :date, :null => false, :index => true
      t.text :note

      t.boolean :finalized, :default => false, :null => false

      t.references :account, :null => false, :index => true

      t.integer :groups, :default => 1, :null => false
      t.integer :size, :default => 30, :null => false
      t.integer :tanks, :default => 2, :null => false
      t.integer :healers, :default => 6, :null => false

      t.integer :requiredLevel
      t.integer :requiredItemLevel

      t.timestamps
    end
  end
end
