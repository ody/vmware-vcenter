provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'vcenter')

Puppet::Type.type(:vc_permission).provide(:vc_permissions, :parent => Puppet::Provider::Vcenter) do
  @doc = "Manages vCenter Folders."

  def create
    entity = vim.searchIndex.FindByInventoryPath({:inventoryPath => @resource[:path]})
    authm = vim.serviceInstance.content.authorizationManager
    roleid = authm.roleList.find { |x| x.name == @resource[:role] }.roleId
    perm = {
      :roleId    => roleid,
      :principal => @resource[:principal],
      :group     => @resource[:group] == :true,
      :propagate => @resource[:propagate] == :true,
    }
    authm.SetEntityPermissions(:entity => entity, :permission => [perm])
  end

  def destroy
    entity = vim.searchIndex.FindByInventoryPath({:inventoryPath => @resource[:path]})
    authm = vim.serviceInstance.content.authorizationManager
    authm.RemoveEntityPermission(
      :entity  => entity,
      :user    => @resource[:principal],
      :isGroup => @resource[:group] == :true,
    )
  end

  def exists?
    entity = vim.searchIndex.FindByInventoryPath({:inventoryPath => @resource[:path]})
    authm = vim.serviceInstance.content.authorizationManager
    !(authm.RetrieveEntityPermissions(:entity => entity, :inherited => false).find { |x|
      x.principal == 'SYSTEM-DOMAIN\\cody'
    }.nil?)
  end
end
