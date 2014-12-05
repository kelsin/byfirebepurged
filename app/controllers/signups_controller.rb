class SignupsController < ApplicationController
  before_action :load_raid

  def index
    authorize! :read, @raid
  end

  def create
    @character = Character.find(signup_params[:character_id])
    @signup = Signup.new(signup_params.merge(:raid => @raid))

    authorize! :create, @signup

    raise Exceptions::ByFireBePurgedError, 'Error signing up for raid' unless @signup.save
    render :show
  end

  def update
    @signup = @raid.signups.find(params[:id])
    authorize! :update, @signup
    raise Exceptions::ByFireBePurgedError, 'Error saving signup' unless @signup.update(signup_params)
    render :show
  end

  def destroy
    @signup = @raid.signups.find(params[:id])
    authorize! :destroy, @signup

    raise Exceptions::ByFireBePurgedError, 'Error deleting signup' unless @signup.destroy
    render :show
  end

  def show
    @signup = @raid.signups.find(params[:id])
    authorize! :read, @signup
  end

  private

  def signup_params
    params.require(:signup).permit(:character_id, :note, :preferred, :seated)
  end

  def load_raid
    @raid = Raid.find(params[:raid_id])
  end
end
