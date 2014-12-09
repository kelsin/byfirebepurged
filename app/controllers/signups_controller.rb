class SignupsController < ApplicationController
  before_action :load_raid, :except => :destroy

  def index
    authorize! :read, @raid
  end

  def create
    @character = Character.find(converted_params[:character_id])
    @signup = Signup.new(converted_params)
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

    if @signup.update(converted_params)
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

  def mappings
    { :character => :character_id,
      :role => :role_id,
      :raid => :raid_id,
      :roles => :role_ids }
  end

  def allowed_params
    if @raid
      if @account.admin?(@raid)
        params.require(:signup).permit(:character, :character_id,
                                       :role, :role_id,
                                       { :roles => [] }, { :role_ids => [] },
                                       :note, :preferred, :seated)
      else
        params.require(:signup).permit(:character, :character_id,
                                       { :roles => [] }, { :role_ids => [] },
                                       :note, :preferred)
      end
    else
      params.require(:signup).permit(:raid, :raid_id)
    end
  end

  def load_raid
    raid_id = params[:raid_id] || converted_params[:raid_id]
    @raid = Raid.find(raid_id) if raid_id
    authorize! :read, @raid if @raid
  end
end
