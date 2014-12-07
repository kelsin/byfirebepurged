class SignupsController < ApplicationController
  before_action :load_raid

  def index
    authorize! :read, @raid
  end

  def create
    @character = Character.find(signup_params[:character_id])
    @signup = Signup.new(signup_params)
    @signup.raid = @raid

    authorize! :create, @signup

    begin
      if @signup.save
        render :show
      else
        raise Exceptions::ByFireBePurgedError.new(@signup.errors), 'Error signing up for raid'
      end
    rescue ActiveRecord::RecordNotUnique
      raise Exceptions::ByFireBePurgedError.new(@signup.errors), 'Already signed up for this raid'
    end
  end

  def update
    @signup = @raid.signups.find(params[:id])

    authorize! :update, @signup

    if @signup.update(signup_params)
      render :show
    else
      raise Exceptions::ByFireBePurgedError.new(@signup.errors), 'Error saving signup'
    end
  end

  def destroy
    @signup = @raid.signups.find(params[:id])
    authorize! :destroy, @signup

    if @signup.destroy
      render :show
    else
      raise Exceptions::ByFireBePurgedError, 'Error deleting signup'
    end
  end

  def show
    @signup = @raid.signups.find(params[:id])
    authorize! :read, @signup
  end

  private

  def signup_params
    params.require(:signup).permit(:character_id, :raid_id, :note, :preferred, :seated, :role)
  end

  def load_raid
    if params[:raid_id]
      @raid = Raid.find(params[:raid_id])
    else signup_params[:raid_id]
      @raid = Raid.find(signup_params[:raid_id])
    end

    authorize! :read, @raid
  end
end
