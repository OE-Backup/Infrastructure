#
# Cookbook Name:: oe-postgresql
# Recipe:: repmgr_slave
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy

include_recipe 'oe-postgresql::repmgr'

# Clone from host master
# ! Should only be done once => subscribe to package installation
execute 'repmgr-slave-clone' do
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

# Register slave database
# ! Should only be done once => subscribe to package installation
execute 'repmgr-slave-register' do
  action  :nothing
  user    node['postgresql']['user']['name']
  command <<-EOC
    #{node['postgresql']['prefix']['install']}/bin/repmgr \
      -f #{node['postgresql']['prefix']['cfg']}/repmgr.conf \
      --verbose \
      standby register \
      >>#{node['postgresql']['prefix']['log']}/repmgr.log 2>&1
  EOC
  not_if "echo '\
      SELECT COUNT(*) \
        FROM repmgr_#{node['repmgr']['config']['cluster']}.repl_nodes \
        WHERE id = #{node['repmgr']['config']['node']};' |\
    psql -td repmgr |\
    awk '/[1-9]$/'  |\
    grep '1'", :user => node['postgresql']['user']['name']
  subscribes  :run, 'cookbook_file[bin/repmgr]'
  subscribes  :run, "package[postgresql-#{node['postgresql']['version']}]"
end

template '/etc/init.d/repmgrd' do
  action    :create
  source    'init.d/repmgrd.erb'
  owner     'root'
  group     'root'
  mode      0755
end

service 'repmgrd' do
  action [ :start, :enable ]
end

