#
# Cookbook Name:: lp2-ss
# Recipe:: tomcat
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "tomcat::default"
include_recipe "tomcat::users"

[ "postgresql-9.2-1002-jdbc4.jar", \
  "catalina-jmx-remote.jar" ].each do |jar|
  remote_file "#{node["tomcat"]["lib_dir"]}/#{jar}" do
    action :create_if_missing
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    mode 0644
    source "#{node["lp2"]["ss"]["jars_url"]}/#{jar}"
  end
end

# download and deploy probe monitoring webapp
remote_file "#{node["tomcat"]["webapp_dir"]}/oe-probe.war" do
  action :create_if_missing
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode 0644
  source "#{node["lp2"]["oe-probe_url"]}"
  checksum "#{node["lp2"]["oe-probe_checksum"]}"
end

lp2_settings = Chef::DataBagItem.load("lp2", "settings")
lp2_secrets = Chef::EncryptedDataBagItem.load("lp2", "secrets")

template "#{node["tomcat"]["config_dir"]}/context.xml" do
  source "context.xml.erb"
  owner "root"
  group node["tomcat"]["group"]
  mode "0644"
  notifies :restart, "service[tomcat]", :delayed
  variables({
    :jdbc_user       => lp2_settings[node.chef_environment.to_s]["ss"]["jdbc_user"],
    :jdbc_pass       =>  lp2_secrets[node.chef_environment.to_s]["ss"]["jdbc_pass"],
    :jdbc_url        => lp2_settings[node.chef_environment.to_s]["ss"]["jdbc_url"],
  })
end

template "#{node["tomcat"]["config_dir"]}/server.xml" do
  source "server.xml.erb"
  owner "root"
  group node["tomcat"]["group"]
  mode "0644"
  notifies :restart, "service[tomcat]", :immediately
end

# it's removed because is not used
#execute "remove-root-context" do
#  user "root"
#  group "root"
#  command "rm -rf #{node["tomcat"]["webapp_dir"]}/ROOT*"
#end

#if node["lp2"]["ss"][node.chef_environment.to_s]["war_url"]
#  remote_file "#{node["tomcat"]["webapp_dir"]}/ws.war" do
#    owner node["tomcat"]["user"]
#    group node["tomcat"]["group"]
#    mode 0644
#    source node["lp2"]["ss"][node.chef_environment.to_s]["war_url"]
#    checksum node["lp2"]["ss"][node.chef_environment.to_s]["war_checksum"]
#  end
#end

cookbook_file "/etc/logrotate.d/tomcat7" do
  owner "root"
  group "root"
  mode "0644"
  source "logrotate_tomcat7"
end

# dedicated log file for the jvm
file "#{node["tomcat"]["log_dir"]}/jvm.log" do
  action :touch
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
end
