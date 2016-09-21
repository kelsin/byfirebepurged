class AddGuildToRaid < ActiveRecord::Migration[4.2]
  def change
    change_table :raids do |t|
      t.references :guild, :index => true
    end
  end
end
