class CreateLogins < ActiveRecord::Migration[3.1]
  def change
    create_table :logins do |t|
      t.string :key, :null => false, :index => true
      t.string :redirect, :null => false
      t.timestamps
    end

    add_index 'logins', ['key', 'created_at'], :name => 'index_logins_on_key_and_created_at'
  end
end
