#
# Cookbook Name:: oe-postgresql
# Recipe:: server_master
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

include_recipe 'oe-postgresql::server'

template "#{node['postgresql']['prefix']['cfg']}/postgresql.conf" do
  action    :create
  source    'postgresql.conf.erb'
  owner     node['postgresql']['user']['name']
  group     node['postgresql']['group']['name']
  mode      0640
  notifies  :restart, 'service[postgresql]', :immediately
end

if node['postgresql']['pg_hba'].nil? then
  raise "#{cookbook_name}::#{recipe_name} node['postgresql']['pg_hba'] is not defined"
end

template "#{node['postgresql']['prefix']['cfg']}/pg_hba.conf" do
  action    :create
  source    'pg_hba.conf.erb'
  owner     node['postgresql']['user']['name']
  group     node['postgresql']['group']['name']
  mode      0640
  notifies  :restart, 'service[postgresql]', :immediately
end

s = resources(:service => 'postgresql')
s.action      :start
s.subscribes  :start, "template[#{node['postgresql']['prefix']['cfg']}/postgresql.conf]", :immediately

