#
# Cookbook Name:: oeinfra
# Recipe:: appdynamics
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute
#
monit = Chef::EncryptedDataBagItem.load(node['monit']['databag'], node['monit']['databag_item'])

if node['monitoring']['monit']['enabled'] == false
    return
end

package "monit"
splitted = node.chef_environment.split('-')
environment = splitted[1]

node.set['oe-monitoring']['ses']['access_key_id'] = monit['aws'][environment]['ses']['access_key_id']
node.set['oe-monitoring']['ses']['secret_access_key'] = monit['aws'][environment]['ses']['secret_access_key']

template "/etc/monit/monitrc" do
  owner "root"
  group "root"
  mode 0600
  source 'monitrc.erb'
end

unless node['tomcat'].nil? or node['tomcat']['java_options'].nil?
  cookbook_file "/etc/monit/conf.d/tomcat7.conf" do
    owner "root"
    group "root"
    mode "0644"
    source "tomcat7"
  end
end

unless [nil, ""].include?(node['apache'])
  cookbook_file "/etc/monit/conf.d/apache2.conf" do
    owner "root"
    group "root"
    mode "0644"
    source "apache2"
  end
end

unless [nil, ""].include?(node['amq'])
  cookbook_file "/etc/monit/conf.d/activemq.conf" do
    owner "root"
    group "root"
    mode "0644"
    source "activemq"
  end
end

service "monit" do
  supports :restart => true
  action :restart
end

