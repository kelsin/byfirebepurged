module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def login
    @session = create :session
    @account = @session.account
    header 'Authorization', "apikey #{@session.key}"
  end

  def create_roles
    @dps     = Role.create(:name => 'DPS', :slug => 'dps', :icon => 'bullseye')
    @healing = Role.create(:name => 'Healing', :slug => 'healing', :icon => 'ambulance')
    @tank    = Role.create(:name => 'Tank', :slug => 'tank', :icon => 'shield')

    (1..11).each do |class_id|
      ClassRole.create(:role => @dps, :class_id => class_id)
    end

    [2, 5, 7, 10, 11].each do |class_id|
      ClassRole.create(:role => @healing, :class_id => class_id)
    end

    [1, 2, 6, 10, 11].each do |class_id|
      ClassRole.create(:role => @tank, :class_id => class_id)
    end
  end
end
