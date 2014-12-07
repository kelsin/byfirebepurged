class PermissionsController < ApplicationController
  before_action :load_permissioned

  def index
    @permissions = @permissioned.permissions
  end

  def create
    @permission = Permission.new(permission_params)
    @permissioned.permissions << @permission
  end

  private

  def permission_params
    params.require(:permission).permit(:level, :key, :permissioned_id, :permissioned_type)
  end

  def load_permissioned
    if params[:raid_id]
      @permissioned = Raid.unscoped.with_permissions.find(params[:raid_id])
    elsif permission_params[:permissioned_type] == 'raid' and permission_params[:permissioned_id]
      @permissioned = Raid.unscoped.with_permissions.find(permission_params[:permissioned_id])
    end

    authorize! :manage, @permissioned
  end
end
