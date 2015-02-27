class AddEmblemToGuilds < ActiveRecord::Migration
  def change
    change_table :guilds do |t|
      t.integer :icon
      t.integer :border
      t.string :icon_color
      t.string :border_color
      t.string :background_color
    end
  end
end
