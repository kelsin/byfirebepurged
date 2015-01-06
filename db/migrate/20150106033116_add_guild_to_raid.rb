class AddGuildToRaid < ActiveRecord::Migration
  def change
    change_table :raids do |t|
      t.references :guild, :index => true
    end
  end
end
