class SignupsController < ApplicationController
  def index
    @raid = Raid.find(params[:raid_id])
    authorize! :read, @raid
  end

  def create
    @raid = Raid.find(params[:raid_id] || converted_params[:raid_id])
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
    @signup = Signup.find(params[:id])
    authorize! :update, @signup

    if can? :manage, @signup.raid
      @signup.seated = params[:signup][:seated] if params[:signup].has_key?(:seated)
      @signup.role_id = params[:signup][:role_id] if params[:signup].has_key?(:role_id)
      @signup.role = params[:signup][:role] if params[:signup].has_key?(:role)
    end

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
    @signup = Signup.find(params[:id])
    authorize! :read, @signup.raid
    authorize! :read, @signup
  end

  private

  def mappings
    { :character => :character_id,
      :raid => :raid_id,
      :roles => :role_ids }
  end

  def allowed_params
    params.require(:signup).permit(:character, :character_id,
                                   :raid, :raid_id,
                                   { :roles => [] }, { :role_ids => [] },
                                   :note, :preferred)
  end
end
