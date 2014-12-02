class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.references :raid, :index => true
      t.references :character, :index => true

      t.string :note
      t.boolean :preferred, :default => false, :null => false
      t.boolean :seated, :default => false, :null => false

      t.timestamps
    end

    add_index 'signups', ['raid_id', 'character_id'], :name => 'index_signups_on_character_id_and_raid_id'
  end
end
