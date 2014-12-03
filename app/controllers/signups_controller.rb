class SignupsController < ApplicationController
  before_action :load_raid

  def index
    authorize! :read, @raid
  end

  def create
    @character = Character.find(signup_params[:character_id])

    @signup = Signup.find_or_create_by(signup_params.merge(:raid => @raid))

    # If you can read the raid, then you can signup for it
    authorize! :create, @signup

    raise Exceptions::ByFireBePurgedError, 'Error signing up for raid' unless @signup.save
  end

  def show
    @signup = @raid.signups.find(params[:id])
    authorize! :read, @signup
  end

  def destroy
    @signup = @raid.signups.find(params[:id])
    authorize! :destroy, @signup

    raise Exceptions::ByFireBePurgedError, 'Error deleting signup' unless @signup.destroy
  end

  private

  def signup_params
    params.require(:signup).permit(:character_id)
  end

  def load_raid
    @raid = Raid.find(params[:raid_id])
  end
end
