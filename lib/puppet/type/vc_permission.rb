# Copyright (C) 2013 VMware, Inc.
Puppet::Type.newtype(:vc_permission) do
  @doc = "Manage vCenter permissions assigned to an entity."

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
    desc "Name of permission"
  end

  newparam(:path) do
    desc "The path to the folder."

    validate do |path|
      raise "Absolute path required: #{value}" unless Puppet::Util.absolute_path?(path)
    end
  end

  newparam(:principal) do
    desc "The user or group for the permission"
  end

  # autorequire vc_folder for this permission (can be datacenter or folder)
  autorequire(:vc_folder) do
    self[:path]
  end

  newparam(:role) do
    desc "The role name"
  end

  newparam(:group) do
    desc "If the principal with be a group"

    defaultto(:false)
  end

  newparam(:propagate) do
    desc "If the principal should propagate to children objects"

    defaultto(:false)
  end
end
