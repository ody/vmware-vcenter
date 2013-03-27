# Copyright (C) 2013 VMware, Inc.
Puppet::Type.newtype(:vc_dvportgroup) do
  @doc = "Manage vCenter Distributed Virtual Portgroups."

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:present)
  end

  newparam(:path, :namevar => true) do
    desc "The path to the Cluster."

    validate do |path|
      raise "Absolute path required: #{value}" unless Puppet::Util.absolute_path?(path)
    end
  end

  newparam(:transport) do
    desc "The connectivity to vCenter."
  end

  newparam(:vlanid) do
    desc "The numeric ID for the VLAN."
  end

  newparam(:count) do
    desc "Total count of virtual ports provisioned for Portgroup"
  end

  autorequire(:vc_dvs) do
    Pathname.new(self[:path]).parent.to_s
  end

end

