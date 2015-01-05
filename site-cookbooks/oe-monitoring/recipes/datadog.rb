#
# Cookbook Name:: oeinfra
# Recipe:: datadog
#
# Copyright 2014, Open English - Federico Aguirre (federico.aguirre@openenglish.com)
#
# All rights reserved - Do Not Redistribute
#

chef_gem 'dogapi'

datadog = Chef::EncryptedDataBagItem.load(node['datadog']['databag'], node['datadog']['databag_item'])
node.set['dd_api_key'] = datadog['DD_API_KEY']

if node['monitoring']['datadog']['enabled'] == false
    return
end

execute "install-datadog" do
    not_if "dpkg -l|grep datadog-agent"
    action :run
    retries 5
    command "DD_API_KEY=#{node['dd_api_key']} bash -c \"$(wget -qO- #{node['datadog']['url']})\""
end

template "/etc/dd-agent/datadog.conf" do
  owner "root"
  group "root"
  mode 0644
  source 'datadog.conf.erb'
end

unless [nil, ""].include?(node['tomcat'])
  template "/etc/dd-agent/conf.d/tomcat.yaml" do
    owner "root"
  	group "root"
  	mode 0644
  	source 'tomcat.yaml.erb'
  end
end

unless [nil, ""].include?(node['dotcms'])
  template "/etc/dd-agent/conf.d/tomcat.yaml" do
    owner "root"
  	group "root"
  	mode 0644
  	source 'tomcat.yaml.erb'
  end
end

unless [nil, ""].include?(node['amq'])
  template "/etc/dd-agent/conf.d/activemq.yaml" do
    owner "root"
  	group "root"
  	mode 0644
  	source 'activemq.yaml.erb'
  end
end

unless [nil, ""].include?(node['apache'])
  template "/etc/dd-agent/conf.d/apache.yaml" do
    owner "root"
  	group "root"
  	mode 0644
  	source 'apache.yaml.erb'
  end
end

unless [nil, ""].include?(node['postgres']  )
  template "/etc/dd-agent/conf.d/postgres.yaml" do
    owner "root"
  	group "root"
  	mode 0644
  	source 'postgres.yaml.erb'
  end
end

service "datadog-agent" do
  supports :start => true, :stop => true, :restart => true, :info => true
  action [:enable, :restart]
end

include_recipe 'oe-monitoring::datadog_alarm'
