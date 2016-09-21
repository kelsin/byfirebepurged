class AddRoleToSignups < ActiveRecord::Migration[4.2]
  def change
    change_table :signups do |t|
      t.belongs_to :role
    end
  end
end
