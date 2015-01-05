#
# Cookbook Name:: oeinfra
# Recipe:: appdynamics
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute
#
datadog = Chef::EncryptedDataBagItem.load(node['appdynamics']['databag'], node['appdynamics']['databag_item'])
node.set['ad_controller_host'] = datadog['controller-host']
node.set['ad_name'] = datadog['name']
node.set['ad_access-key'] = datadog['access-key']

if node['monitoring']['appdynamics']['enabled'] == false
    return
end

if defined?(node['amq']['java_options'])
    node.set['amq']['java_options'] = node['amq']['java_options'] + node['appdynamics']['java_options']
    node.set['appdynamics']['service'] = 'activemq'
end

unless node['tomcat'].nil? or node['tomcat']['java_options'].nil?
    node.set['tomcat']['java_options'] = node['tomcat']['java_options'] + node['appdynamics']['java_options']
    node.set['appdynamics']['service'] = 'tomcat'
    node.set['appdynamics']['agent']['user']  = node['tomcat']['user']
    node.set['appdynamics']['agent']['group'] = node['tomcat']['group']
end

unless [nil, ""].include?(node['appdynamics']['service'])
  r = resources(service: "#{node['appdynamics']['service']}")
  r.action :nothing
end

package "unzip"

directory node['appdynamics']['base'] do
   recursive true
   owner node['appdynamics']['user']
   group node['appdynamics']['group']
   mode 0775
end

directory node['appdynamics']['agent']['install_dir'] do
   recursive true
   owner node['appdynamics']['agent']['user']
   group node['appdynamics']['agent']['group']
   mode 0775
end

remote_file "#{node['appdynamics']['agent']['install_dir']}/AppServerAgent.zip" do
  action :create_if_missing
  owner node['appdynamics']['agent']['user']
  group node['appdynamics']['agent']['group']
  mode 0644
  source "#{node['filerepo_host']}infra-packages/appDynamics/AppServerAgent.zip"
  checksum node['appdynamics']['agent']['checksum']
  notifies :run, 'execute[unzip-agent-file]', :immediately
end

install_dir = node['appdynamics']['agent']['install_dir']
zip_file = "#{node['appdynamics']['agent']['install_dir']}/AppServerAgent.zip"
execute "unzip-agent-file" do
    action :nothing
    command "unzip #{zip_file} -d #{install_dir}"
    user node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']
end

template "/opt/appDynamics/AppServerAgent/conf/controller-info.xml" do
  owner "root"
  group "root"
  mode 0644
  source 'controller-info-agent.xml.erb'
  unless [nil, ""].include?(node['appdynamics']['service'])
    notifies :start, "service[#{node['appdynamics']['service']}]", :delayed
  end
end

directory node['appdynamics']['machine']['install_dir'] do
   recursive true
   owner node['appdynamics']['machine']['user']
   group node['appdynamics']['machine']['group']
   mode 0775
end

remote_file "#{node['appdynamics']['machine']['install_dir']}/MachineAgent.zip" do
  action :create_if_missing
  owner node['appdynamics']['machine']['user']
  group node['appdynamics']['machine']['group']
  mode 0644
  source "#{node['filerepo_host']}infra-packages/appDynamics/MachineAgent.zip"
  checksum node['appdynamics']['machine']['checksum']
  notifies :run, 'execute[unzip-machine-file]', :immediately
end

install_dir = node['appdynamics']['machine']['install_dir']
zip_file = "#{node['appdynamics']['machine']['install_dir']}/MachineAgent.zip"
execute "unzip-machine-file" do
    action :nothing
    command "unzip #{zip_file} -d #{install_dir}"
    user node['appdynamics']['machine']['user']
    group node['appdynamics']['machine']['group']
end

template "/opt/appDynamics/MachineAgent/conf/controller-info.xml" do
  owner "root"
  group "root"
  mode 0644
  source 'controller-info-machine.xml.erb'
end

cookbook_file "/etc/init.d/appdynamics" do
  owner "root"
  group "root"
  mode "0755"
  source "appdynamics"
end

service_file = "appdynamics"
execute "create-service" do
    action :run
    command "update-rc.d #{service_file} defaults"
    notifies :restart, 'service[appdynamics]', :immediately
end

ruby_block "foo" do
  block do
    file = "/etc/default/tomcat7"
    if File.exist?(file) && !system("grep javaagent /etc/default/tomcat7")
      file = File.open('/etc/default/tomcat7', 'a+')
        file.syswrite "JAVA_OPTS=\"${JAVA_OPTS} -javaagent:/opt/appDynamics/AppServerAgent/javaagent.jar\""
      file.close()
    end  
  end
end

service "appdynamics" do
  supports :start => true, :restart => true
  action :nothing
end
