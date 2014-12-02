class CreateGuilds < ActiveRecord::Migration
  def change
    create_table :guilds do |t|
      t.string :name
      t.string :realm
      t.timestamps
    end

    add_index 'guilds', ['name', 'realm'], :name => 'index_guilds_on_name_and_realm'
  end
end
