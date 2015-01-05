#
# Cookbook Name:: lp2-ui
# Recipe:: tomcat
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
# UI webapp uses tomcat as backend application server
include_recipe "tomcat::default"
include_recipe "tomcat::users"
include_recipe 'oe-tomcat::libs'

require 'digest/md5'
require 'fileutils'

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
    :jdbc_user       => lp2_settings[node.chef_environment.to_s]["ui"]["jdbc_user"],
    :jdbc_pass       =>  lp2_secrets[node.chef_environment.to_s]["ui"]["jdbc_pass"],
    :jdbc_url        => lp2_settings[node.chef_environment.to_s]["ui"]["jdbc_url"],
    :memcached_nodes => lp2_settings[node.chef_environment.to_s]["ui"]["memcached_nodes"]
  })
end

template "#{node["tomcat"]["config_dir"]}/server.xml" do
  source "server.xml.erb"
  owner "root"
  group node["tomcat"]["group"]
  mode "0644"
  notifies :restart, "service[tomcat]", :delayed
end

default_index_file = "#{node["tomcat"]["webapp_dir"]}/ROOT/index.html"
default_index_checksum = lp2_settings[node.chef_environment]["tp"]["tomcat"]["default_index_checksum"]

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
