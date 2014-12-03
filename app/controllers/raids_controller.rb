class RaidsController < ApplicationController
  def index
    @raids = @account.available_raids

    @raids.each do |raid|
      authorize! :read, raid
    end

    @all_signups = @raids.inject([]) do |signups, raid|
      signups + raid.signups
    end
    @all_characters = @all_signups.map(&:character).uniq.sort
    @all_guilds = @all_characters.map(&:guild).uniq.sort
  end

  def show
    @raid = Raid.includes(:signups => { :character => :guild }).where(:id => params[:id]).first

    authorize! :read, @raid
  end

  def update
    @raid = Raid.find(params[:id])
    authorize! :update, @raid
    raise Exceptions::ByFireBePurgedError, 'Error saving raid' unless @raid.update(raid_params)
  end

  def create
    authorize! :create, Raid

    @raid = Raid.new(raid_params)
    @raid.account = @account
    @raid.permissions << Permission.new(:key => @account.to_permission, :level => 'admin')

    raise Exceptions::ByFireBePurgedError, 'Error saving raid' unless @raid.save
  end

  private

  def raid_params
    params.require(:raid).permit(:name, :date, :finalized, :note,
                                 :groups, :size, :tanks, :healers)
  end
end
