class RaidsController < ApplicationController
  def index
    @raids = @account.available_raids

    @raids.each do |raid|
      authorize! :read, raid
    end
  end

  def show
    @raid = Raid.find(params[:id])
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
