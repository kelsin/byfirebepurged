class ApplicationController < ActionController::Base
  rescue_from ::Exceptions::ByFireBePurgedError, :with => :error
  rescue_from ::CanCan::AccessDenied, :with => :error

  before_action :authenticate
  check_authorization

  helper_method :current_account

  private

  def current_account
    @account
  end

  def current_ability
    @current_ability ||= Ability.new(current_account)
  end

  def authenticate
    authorization = request.headers['Authorization']
    m = /apikey ([\w]{8}-[\w]{4}-[\w]{4}-[\w]{4}-[\w]{12})/.match(authorization)
    key = m[1]

    raise Exceptions::ByFireBePurgedError, "Unable to parse apikey: #{authorization}" unless key

    @session = Session.includes(:account).find_by_key(key)
    raise Exceptions::ByFireBePurgedError, "Invalid apikey: #{key}" unless @session

    @account = @session.account
    @characters = @account.characters
    @guilds = @account.guilds
    @signups = @account.signups
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
