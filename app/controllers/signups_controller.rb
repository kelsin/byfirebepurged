class SignupsController < ApplicationController
  before_action :load_raid, :except => :destroy

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
        raise Exceptions::ByFireBePurgedError.new(@signup.errors.messages), 'Error signing up for raid'
      end
    rescue ActiveRecord::RecordNotUnique
      raise Exceptions::ByFireBePurgedError.new(@signup.errors.messages), 'Already signed up for this raid'
    end
  end

  def update
    @signup = @raid.signups.find(params[:id])

    authorize! :update, @signup

    if @signup.update(signup_params)
      render :show
    else
      raise Exceptions::ByFireBePurgedError.new(@signup.errors.messages), 'Error saving signup'
    end
  end

  def destroy
    @signup = Signup.find(params[:id])
    authorize! :read, @signup.raid
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
    elsif signup_params[:raid_id]
      @raid = Raid.find(signup_params[:raid_id])
    end

    authorize! :read, @raid if @raid
  end
end
