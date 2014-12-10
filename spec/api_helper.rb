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
end
