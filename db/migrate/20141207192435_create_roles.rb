class CreateRoles < ActiveRecord::Migration[3.1]
  def change
    create_table :roles do |t|
      t.string 'name'
      t.string 'slug', :index => true
      t.string 'icon'
      t.timestamps
    end

    create_table :class_roles do |t|
      t.belongs_to :role, :index => true
      t.belongs_to :class, :index => true
    end

    create_table :roles_signups, :id => false do |t|
      t.belongs_to :role, :index => true
      t.belongs_to :signup, :index => true
    end

    dps     = Role.create(:name => 'DPS', :slug => 'dps', :icon => 'bullseye')
    healing = Role.create(:name => 'Healing', :slug => 'healing', :icon => 'ambulance')
    tank    = Role.create(:name => 'Tank', :slug => 'tank', :icon => 'shield')

    (1..11).each do |class_id|
      ClassRole.create(:role => dps, :class_id => class_id)
    end

    [2, 5, 7, 10, 11].each do |class_id|
      ClassRole.create(:role => healing, :class_id => class_id)
    end

    [1, 2, 6, 10, 11].each do |class_id|
      ClassRole.create(:role => tank, :class_id => class_id)
    end
  end
end
