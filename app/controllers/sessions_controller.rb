require 'bnet'

class SessionsController < ApplicationController
  skip_before_action :authenticate, :except => :destroy
  skip_authorization_check

  @@bnet = Bnet.new

  # Provides some static data to point users to the proper API requests and
  # websites.
  def index
  end

  # Attempts to login to the api. You must pass in a json body in the following form:
  #
  #     {
  #       "redirect": "https://localhost/?key="
  #     }
  #
  # The response will look like:
  #
  #     {
  #       "method": "Battle.net OAuth 2.0",
  #       "href": "https://localhost:3000/auth/bnet?key=960c109e-af1f-4012-9e8a-31783a3e9270"
  #     }
  #
  # To complete a login, forward your user to the provided href value, and then
  # we will redirect to your original redirect value with your proper API key
  # appended. In our example we would redirect to a url like:
  #
  #     https://localhost/?key=51032c55-5ff6-4ee7-887c-3d2e2f3587e1
  #
  # From now on just append the following header to all API requests:
  #
  #     Authorization: apikey 51032c55-5ff6-4ee7-887c-3d2e2f3587e1
  def new
    raise Exceptions::ByFireBePurgedError, 'Must provide a redirect value' unless params[:redirect]

    redirect = URI.parse(params[:redirect]) rescue nil

    unless redirect.kind_of?(URI::HTTP) or redirect.kind_of?(URI::HTTPS)
      raise Exceptions::ByFireBePurgedError, 'Redirect value must be a valid http or https url'
    end

    @login = Login.create(:key => SecureRandom.uuid,
                          :redirect => params[:redirect])
  end

  # This is the OAuth redirect route that we use when using Battle.net's OAuth
  # authentication.
  #
  # This route creates or saves the user with the proper account_id and
  # battletag and then loads their WoW characters and redirects to the original
  # redirect url provided by the user when they hit +new+
  def create
    # First find the login record created for this authentication attempt
    @login = Login.find_by_key(params_hash['key'])
    raise Exceptions::ByFireBePurgedError, "Can not find login request for #{params_hash['key']}" unless @login

    # Now find or create the account for this Battle.net account
    begin
      @account = Account.find_or_initialize_by(:account_id => auth_hash['info']['id'])
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    unless @account and @account.update(:battletag => auth_hash['info']['battletag'])
      raise Exceptions::ByFireBePurgedError, 'Error attempting to find and update account'
    end

    # Now create a session for this user
    @session = Session.create(:access_token => auth_hash['credentials']['token'],
                              :account_id => @account.id,
                              :key => SecureRandom.uuid)

    raise Exceptions::ByFireBePurgedError, 'Error creating session' unless @session

    # Update characters if it's been an hour since last login
    update_characters

    redirect_to "#{@login.redirect}#{@session.key}"
  end

  def destroy
    @session.try(:destroy)

    render :json => { :logged_out => true }
  end

  private

  # Helper to easily get the omniauth data from the request
  def auth_hash
    request.env['omniauth.auth']
  end

  # Helper to easily get the omniauth params from the request
  def params_hash
    request.env['omniauth.params']
  end

  # Update the accounts characters from the Battle.net api
  def update_characters
    @@bnet.characters(@session.access_token).each do |character|
      guild = nil
      if character['guild'].present? and character['guildRealm'].present?
        guild = Guild.find_or_create_by(:name => character['guild'],
                                        :realm => character['guildRealm'])
      end

      c = Character.find_or_initialize_by(:account_id => @session.account_id,
                                          :name => character['name'],
                                          :realm => character['realm'])
      c.update(:guild_id => guild.try(:id),
               :image_url => image_url(character),
               :level => character['level'],
               :race_id => character['race'],
               :class_id => character['class'],
               :gender_id => character['gender'])

      c.update(:item_level => @@bnet.ilvl(c.name, c.realm)) if c.level >= 100
    end
  end

  # Full image url from api character data
  def image_url(character)
    "https://us.battle.net/static-render/us/#{character['thumbnail']}?alt=wow/static/images/2d/avatar/#{character['race']}-#{character['gender']}.jpg"
  end
end
