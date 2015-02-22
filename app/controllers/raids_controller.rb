class RaidsController < ApplicationController
  def index
    authorize! :read, Raid

    @raids = @account.available_raids

    @raids.each do |raid|
      authorize! :read, raid
    end

    add_other_data
  end

  def show
    @raid = Raid.includes(:signups => { :character => :guild }).where(:id => params[:id]).first

    authorize! :read, @raid
  end

  def update
    @raid = Raid.find(params[:id])
    authorize! :update, @raid
    raise Exceptions::ByFireBePurgedError, 'Error saving raid' unless @raid.update(converted_params)
    render :show
  end

  def create
    authorize! :create, Raid

    @raid = Raid.new(converted_params)
    @raid.account = @account
    @raid.permissions << Permission.new(:key => @account.to_permission, :level => 'admin')

    raise Exceptions::ByFireBePurgedError, 'Error saving raid' unless @raid.save
    render :show
  end

  def destroy
    @raid = Raid.find(params[:id])
    authorize! :destroy, @raid
    raise Exceptions::ByFireBePurgedError, 'Error deleting raid' unless @raid.destroy
    render :show
  end

  private

  def mappings
    { :guild => :guild_id }
  end

  def allowed_params
    params.require(:raid).permit(:name, :date, :finalized, :note, :hidden,
                                 :guild, :guild_id,
                                 :groups, :size, :tanks, :healers,
                                 :requiredLevel, :requiredItemLevel)
  end

  def add_other_data
    @all_signups = @raids.inject([]) do |signups, raid|
      signups + raid.signups
    end.uniq.compact.sort
    @all_characters = @all_signups.map(&:character).uniq.sort
    @all_accounts = (@raids.map(&:account) + @all_characters.map(&:account)).uniq.sort
    @all_guilds = @raids.inject([]) do |guilds, raid|
      guilds + raid.guilds
    end.uniq.compact.sort
    @all_permissions = @raids.inject([]) do |permissions, raid|
      if can? :manage, raid
        raid.permissions
      else
        []
      end + permissions
    end.uniq.compact.sort
  end
end
