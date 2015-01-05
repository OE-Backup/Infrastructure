#
# Cookbook Name:: oe-postgresql
# Recipe:: repmgr_ro
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy

include_recipe 'oe-postgresql::repmgr'

# Clone from host master
# ! Should only be done once => subscribe to package installation
execute 'repmgr-ro-clone' do
  action  :nothing
  user    node['postgresql']['user']['name']
  command <<-EOC
    #{node['postgresql']['prefix']['install']}/bin/repmgr \
      -D #{node['postgresql']['prefix']['data']} \
      -d #{node['repmgr']['db']['db']} \
      -U #{node['repmgr']['db']['user']} \
      -p #{node['postgresql']['config']['conns']['port']} \
      -R #{node['postgresql']['user']['name']} \
      -w #{node['postgresql']['config']['replication']['wal_keep_segments']} \
      --verbose \
      standby clone \
      #{node['postgresql']['master']} \
      >>#{node['postgresql']['prefix']['log']}/repmgr.log 2>&1
  EOC
  subscribes  :run,     'cookbook_file[bin/repmgr]'
  subscribes  :run,     "package[postgresql-#{node['postgresql']['version']}]"
  notifies    :restart, 'service[postgresql]', :immediately 
end

