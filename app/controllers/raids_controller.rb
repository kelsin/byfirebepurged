class RaidsController < ApplicationController
  def index
    @raids = @account.available_raids
  end

  def show
    @raid = Raid.find(params[:id])
  end

  def update
    @raid = Raid.find(params[:id])
    raise Exceptions::ByFireBePurgedError, 'Error saving raid' unless @raid.update(raid_params)
  end

  def create
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
