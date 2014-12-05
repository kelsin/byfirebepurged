class ApplicationController < ActionController::Base
  rescue_from ::Exceptions::ByFireBePurgedError, :with => :error
  rescue_from ::Exceptions::AuthenticationError, :with => :unauthorized
  rescue_from ::CanCan::AccessDenied, :with => :error
  rescue_from ::ActiveRecord::RecordNotFound, :with => :not_found

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
    raise ::Exceptions::AuthenticationError, "Must provide Authorization header" unless authorization

    key = /apikey ([\w]{8}-[\w]{4}-[\w]{4}-[\w]{4}-[\w]{12})/.match(authorization).try(:[], 1)
    raise ::Exceptions::AuthenticationError, "Unable to parse apikey" unless key

    @session = Session.includes(:account).find_by_key(key)
    raise ::Exceptions::AuthenticationError, "Invalid apikey" unless @session

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
