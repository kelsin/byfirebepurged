class AddRoleToSignups < ActiveRecord::Migration[3.1]
  def change
    change_table :signups do |t|
      t.belongs_to :role
    end
  end
end
