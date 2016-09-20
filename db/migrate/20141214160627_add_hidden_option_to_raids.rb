class AddHiddenOptionToRaids < ActiveRecord::Migration[3.1]
  def change
    change_table :raids do |t|
      t.boolean :hidden, :default => true, :null => false
    end
  end
end
