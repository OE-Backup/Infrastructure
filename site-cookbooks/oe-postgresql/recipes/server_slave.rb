#
# Cookbook Name:: oe-postgresql
# Recipe:: master_slave
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

include_recipe 'oe-postgresql::repmgr'

if node['postgresql']['server']['type'] != 'slave' then
  v = 'node[postgresql][server][type]'
  Chef::Log.warn("#{cookbook_name}::#{recipe_name}: Recipe should be called when #{v} is slave")
  return
end

if node['postgresql']['master'].nil? then
  raise "#{cookbook_name}::#{recipe_name}: you must define node[postgresql][master] (host / ip) to clone a database"
end

#s = resources(:service => 'postgresql')
#s.action :stop

# Symlink files to match the ones cloned by repmgr
# (performed in repmgr_slave)
%w{ postgresql.conf pg_hba.conf }.each { |f|
  link "#{node['postgresql']['prefix']['cfg']}/#{f}"  do
    action  :create
    owner   node['postgresql']['user']['name']
    to      "#{node['postgresql']['prefix']['data']}/#{f}"
  end
}

# Whipe out package directory initialization
# ! Should only be done once => subscribe to package installation
execute 'slave-init-data-directory' do
  action      :nothing
  command     "rm -rf #{node['postgresql']['prefix']['data']}/*"
  subscribes  :run, "package[postgresql-#{node['postgresql']['version']}]", :immediately
end

