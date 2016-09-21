class AddKeyToAccount < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :key, :string, :null => true

    reversible do |dir|
      dir.up do
        Account.all.each do |account|
          account.key = SecureRandom.uuid
          account.save!
        end

        change_column :accounts, :key, :string, :null => false, :index => true
      end
    end
  end
end
