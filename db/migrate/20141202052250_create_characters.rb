class CreateCharacters < ActiveRecord::Migration[4.2]
  def change
    create_table :characters do |t|
      t.references :account, :index => true
      t.references :guild, :index => true

      t.string :name
      t.string :realm

      t.string :image_url

      t.integer :level
      t.integer :item_level

      t.integer :race_id
      t.integer :class_id
      t.integer :gender_id

      t.timestamps
    end

    add_index 'characters', ['name', 'realm'], :name => 'index_characters_on_name_and_realm'
  end
end
