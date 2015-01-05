#
# Cookbook Name:: oe-postgresql
# Recipe:: server_type
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

# The attribute has not been set. Try to get it from the node name

node.override['postgresql']['server']['type'] = node.name[/master$/] || \
  node.name[/slave$/] ||\
  node.name[/ro$/] ||\
  nil if node['postgresql']['server']['type'].nil?

case node['postgresql']['server']['type']
  when 'master'
    include_recipe 'oe-postgresql::server_master'
    include_recipe 'oe-postgresql::create_users'
    include_recipe 'oe-postgresql::create_db'
    include_recipe 'oe-postgresql::repmgr_master'
  when 'slave'
    include_recipe 'oe-postgresql::server_slave'
    include_recipe 'oe-postgresql::repmgr_slave'
  when 'ro'
    include_recipe 'oe-postgresql::server_ro'
    include_recipe 'oe-postgresql::repmgr_ro'
  else
    raise "#{cookbook_name}::#{recipe_name}: Valid values for node[postgresql][server][type] are master|slave|ro"
end

