class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :account, :null => false, :index => true
      t.string :key, :null => false, :index => true
      t.string :access_token, :null => false
      t.timestamps
    end
  end
end
