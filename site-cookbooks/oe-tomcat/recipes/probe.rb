#
# Cookbook Name:: oe-tomcat
# Recipe:: probe
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute

return unless node['tomcat']['deploy_probe']

remote_file "#{node['tomcat']['dirs']['webapp']}/oe-probe.war" do
  action    :create_if_missing
  owner     node['tomcat']['user']
  group     node['tomcat']['group']
  mode      '0644'
  source    "#{node['tomcat']['probe_war']}"
  checksum  "#{node['tomcat']['probe_checksum']}"
end

