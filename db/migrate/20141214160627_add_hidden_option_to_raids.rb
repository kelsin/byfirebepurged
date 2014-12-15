class AddHiddenOptionToRaids < ActiveRecord::Migration
  def change
    change_table :raids do |t|
      t.boolean :hidden, :default => true, :null => false
    end
  end
end
