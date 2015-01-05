#
# Cookbook Name:: oeinfra
# Recipe:: disk
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#
# Required attributes:
#   - mount_point
#
# Optional attributes:
#   - label:  Partition and filesystem label
#   - fstype: Filesystem type. Only Ext family is supported (for now)
#
# "oeinfra": {
#   "disks": {
#     "xvdf": { "mount_point": "/media", "label": "SOME_label" }
#   }
# }


return if node['oeinfra']['disks'].nil? 

at = "#{cookbook_name}::#{recipe_name}"

ruby_block 'disk-partition' do

  block do
    node['oeinfra']['disks'].each { |disk,disk_attrs|
      
      if node['block_device'][disk].nil? then
        Chef::Log.warn("#{at}: Disk #{disk} does not exist")
        next
      end

      if disk_attrs['mount_point'].nil? then
        raise Chef::Log.warn("#{at}: Disk #{disk} mount point is not defined")
      end

      # Define some defaults for optional attributes if unset
      label  = disk['label']  || "#{disk}1"
      fstype = disk['fstype'] || "ext4"

      c1 = Chef::Resource::Execute.new("disk-partition-#{disk}", run_context)
      c1.command "parted -s -- /dev/#{disk} mklabel gpt mkpart #{label} ext3 0 -0"
      c1.not_if  "parted -s /dev/#{disk}1 2>/dev/null"
      c1.run_action :run

      c2 = Chef::Resource::Execute.new("disk-mkfs-#{disk}", run_context)
      c2.command "mkfs.#{fstype} -L #{label} /dev/#{disk}1"
      c2.not_if  "tune2fs -l /dev/#{disk}1 2>/dev/null"
      c2.run_action :run
      
      d = Chef::Resource::Directory.new("disk-mount-point-check", run_context)
      d.path        disk_attrs['mount_point']
      d.recursive   true
      d.not_if      { File.directory?(disk_attrs['mount_point']) }
      d.run_action  :create

      m1 = Chef::Resource::Mount.new("disk-mount", run_context)
      m1.mount_point  disk_attrs['mount_point']
      m1.device       label
      m1.device_type  :label
      m1.fstype       fstype
      m1.run_action   :enable
      m1.run_action   :mount

    }
  end
  action  :run
end
