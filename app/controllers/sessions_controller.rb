class SessionsController < ApplicationController
  def new
    raise Exceptions::ByFireBePurgedError, 'Must provide a redirect value' unless params[:redirect]

    redirect = URI.parse(params[:redirect]) rescue nil

    unless redirect.kind_of?(URI::HTTP) or redirect.kind_of?(URI::HTTPS)
      raise Exceptions::ByFireBePurgedError, 'Redirect value must be a valid http or https url'
    end

    @login = Login.create(:key => SecureRandom.uuid,
                          :redirect => params[:redirect])
  end

  def create
    logger.debug auth_hash
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
