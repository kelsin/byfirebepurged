class ApplicationController < ActionController::Base
  rescue_from Exceptions::ByFireBePurgedError, :with => :error

  private

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
