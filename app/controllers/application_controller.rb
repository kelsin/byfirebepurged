class ApplicationController < ActionController::Base
  rescue_from ::Exceptions::ByFireBePurgedError, :with => :error

  before_action :authenticate

  private

  def authenticate
    authorization = request.headers['Authorization']
    m = /apikey ([\w]{8}-[\w]{4}-[\w]{4}-[\w]{4}-[\w]{12})/.match(authorization)
    key = m[1]

    raise Exceptions::ByFireBePurgedError, "Unable to parse apikey: #{authorization}" unless key

    @session = Session.includes(:account => { :characters => { :signups => :raids }}).find_by_key(key)
    @account = @session.account
    @characters = @account.characters
    @guilds = @account.guilds
    @signups = @account.signups
    @raids = @account.raids

    raise Exceptions::ByFireBePurgedError, "Invalid apikey: #{key}" unless @session
  end

  def unauthorized(e)
    render :json => {:error => e.message}, :status => :unauthorized
  end

  def not_found
    render :json => {:error => 'Not Found'}, :status => :not_found
  end

  def error(e)
    render :json => {:error => e.message}, :status => :bad_request
  end
end
