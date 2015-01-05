#
# Cookbook Name:: pp2-store2
# Recipe:: tomcat
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
# Store2 webapp uses tomcat as backend application server
include_recipe "oe-tomcat::default"
include_recipe "tomcat::users"
require 'digest/md5'
require 'fileutils'

[ "kryo-1.04.jar",              \
  "msm-kryo-serializer-1.6.5.jar",              \
  "couchbase-client-1.1.4.jar",              \
  "memcached-session-manager-1.6.5.jar",     \
  "memcached-session-manager-tc7-1.6.5.jar", \
  "catalina-jmx-remote.jar",                 \
  "spymemcached-2.10.3.jar"].each do |jar|
  remote_file "#{node["tomcat"]["lib_dir"]}/#{jar}" do
    action :create_if_missing
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    mode 0644
    source "#{node["store2"]["jars_url"]}/#{jar}"
  end
end

# download and deploy probe monitoring webapp
remote_file "#{node["tomcat"]["webapp_dir"]}/oe-probe.war" do
  action :create_if_missing
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  mode 0644
  source "#{node["pp2"]["oe-probe_url"]}"
  checksum "#{node["pp2"]["oe-probe_checksum"]}"
end

pp2_settings = Chef::DataBagItem.load("pp2", "store2")
pp2_secrets = Chef::EncryptedDataBagItem.load("pp2", "store2-secrets")

template "#{node["tomcat"]["config_dir"]}/context.xml" do
  source "context.xml.erb"
  owner "root"
  group node["tomcat"]["group"]
  mode "0644"
  notifies :restart, "service[tomcat]", :delayed
  variables({
    :conf_file_value => pp2_settings[node.chef_environment.to_s]["store2"]["conf_file_value"],
    :memcached_nodes => pp2_settings[node.chef_environment.to_s]["store2"]["memcached_nodes"]
  })
end

template "#{node["tomcat"]["config_dir"]}/server.xml" do
  source "server.xml.erb"
  owner "root"
  group node["tomcat"]["group"]
  mode "0644"
  notifies :restart, "service[tomcat]", :immediately
end

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
