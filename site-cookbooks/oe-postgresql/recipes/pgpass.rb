#
# Cookbook Name:: oe-postgresql
# Recipe:: pgpass
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

raise "#{cookbook_name}::#{recipe_name}: You must define node[postgresql][databag_item]" if node['postgresql']['databag_item'].nil?

if node['disable_encrypted_databags'].nil? or not node['disable_encrypted_databags']
  dbi = Chef::EncryptedDataBagItem.load(
    node['postgresql']['databag'], 
    node['postgresql']['databag_item'], 
  )
else
  dbi = Chef::DataBagItem.load(
    node['postgresql']['databag'], 
    node['postgresql']['databag_item'], 
  )
end

pg_pass = dbi.to_hash[node.chef_environment.split('-').last]

# FIXME:
#  - Improve with a search ?
#  - Keep it as a hash ?
cnt = "# Chef managed file\n"

node['postgresql']['cluster']['hosts'].each { |host|
  cnt <<="#{host}:#{node['postgresql']['config']['conns']['port']}:*:repmgr:#{pg_pass['repmgr']['password']}\n"
} unless node['postgresql']['cluster'].nil? or node['postgresql']['cluster']['hosts'].nil?

file "#{node['postgresql']['prefix']['home']}/.pgpass" do
  action    :create
  owner     node['postgresql']['user']['name']
  group     node['postgresql']['group']['name']
  mode      0600
  content   cnt
end

