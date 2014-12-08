class AddRoleToSignups < ActiveRecord::Migration
  def change
    change_table :signups do |t|
      t.belongs_to :role
    end
  end
end
