#
# Cookbook Name:: oe-tomcat
# Recipe:: config
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'oe-ssl'
include_recipe 'oe-tomcat::service'

# Make sure every directory exists
node['tomcat']['dirs'].each do |k,d|
  directory d do
    action  :create
    owner   node['tomcat']['user']
    group   node['tomcat']['group']
    mode    '0750'
  end
end

template "#{node['tomcat']['dirs']['config']}/server.xml" do
  action    :create
  source    'conf/server.tomcat.xml.erb'
  owner     node['tomcat']['user']
  group     node['tomcat']['group']
  mode      '0640'
  notifies  :restart, 'service[tomcat]', :delayed
end

template '/etc/default/tomcat7' do
  action    :create
  source    'default/tomcat7.erb'
  owner     node['tomcat']['user']
  group     node['tomcat']['group']
  mode      '0644'
  notifies  :restart, "service[tomcat]", :delayed
end

