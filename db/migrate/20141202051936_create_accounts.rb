class CreateAccounts < ActiveRecord::Migration[3.1]
  def change
    create_table :accounts do |t|
      t.string 'battletag'
      t.string 'account_id', :index => true
      t.boolean 'admin', :default => false, :null => false
      t.timestamps
    end
  end
end
