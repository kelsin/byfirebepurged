class PermissionsController < ApplicationController
  before_action :load_permissioned, :except => :destroy

  def index
    @permissions = @permissioned.permissions
  end

  def create
    @permission = Permission.new(permission_params)
    @permissioned.permissions << @permission
  end

  def destroy
    @permission = Permission.find(params[:id])
    authorize! :manage, @permission.permissioned
    @permission.destroy
    render :create
  end

  private

  def permission_params
    params.require(:permission).permit(:level, :key, :permissioned_id, :permissioned_type)
  end

  def load_permissioned
    if params[:raid_id]
      @permissioned = Raid.unscoped.with_permissions.find(params[:raid_id])
    elsif permission_params[:permissioned_type] == 'Raid' and permission_params[:permissioned_id]
      @permissioned = Raid.unscoped.with_permissions.find(permission_params[:permissioned_id])
    end

    authorize! :manage, @permissioned
  end
end
