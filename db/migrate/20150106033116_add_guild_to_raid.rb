class AddGuildToRaid < ActiveRecord::Migration[3.1]
  def change
    change_table :raids do |t|
      t.references :guild, :index => true
    end
  end
end
