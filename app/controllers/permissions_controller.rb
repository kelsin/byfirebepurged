class PermissionsController < ApplicationController
  before_action :load_permissioned

  def index
    authorize! :read, @permissioned
    @permissions = @permissioned.permissions
  end

  def create
    authorize! :manage, @permissioned
    @permission = Permission.new(permission_params)
    @permissioned.permissions << @permission
  end

  private

  def permission_params
    params.require(:permission).permit(:level, :key)
  end

  def load_permissioned
    if params[:raid_id]
      @permissioned = Raid.find(params[:raid_id])
    end
  end
end
