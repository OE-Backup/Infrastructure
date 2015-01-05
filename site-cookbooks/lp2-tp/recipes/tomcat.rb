#
# Cookbook Name:: lp2-tp
# Recipe:: tomcat
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
# TP webapp uses tomcat as backend application server
include_recipe "tomcat::default"
include_recipe "tomcat::users"
require 'digest/md5'
require 'fileutils'

[ "postgresql-9.2-1002-jdbc4.jar", \
  "catalina-jmx-remote.jar"].each do |jar|
  remote_file "#{node["tomcat"]["lib_dir"]}/#{jar}" do
    action :create_if_missing
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    mode 0644
    source "#{node["lp2"]["tp"]["jars_url"]}/#{jar}"
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
    :jdbc_user => lp2_settings[node.chef_environment.to_s]["tp"]["jdbc_user"],
    :jdbc_pass =>  lp2_secrets[node.chef_environment.to_s]["tp"]["jdbc_pass"],
    :jdbc_url  => lp2_settings[node.chef_environment.to_s]["tp"]["jdbc_url"]
  })
end

template "#{node["tomcat"]["config_dir"]}/server.xml" do
  source "server.xml.erb"
  owner "root"
  group node["tomcat"]["group"]
  mode "0644"
  notifies :restart, "service[tomcat]", :immediately
end

default_index_file = "#{node["tomcat"]["webapp_dir"]}/ROOT/index.html"
default_index_checksum = lp2_settings[node.chef_environment]["tp"]["tomcat"]["default_index_checksum"]

# undeploy default Debian ROOT context
#ruby_block "undeploy-debian-root-context" do
#  only_if { File.exists?(default_index_file) }
#  block do
#    if Digest::MD5.hexdigest(File.read(default_index_file)).eql?(default_index_checksum)
#      FileUtils.rm_rf "#{node["tomcat"]["webapp_dir"]}/ROOT"
#    end
#  end
#end

#if node["lp2"]["tp"][node.chef_environment.to_s]["war_url"]
#  remote_file "#{node["tomcat"]["webapp_dir"]}/ROOT.war" do
#    owner node["tomcat"]["user"]
#    group node["tomcat"]["group"]
#    mode 0644
#    source node["lp2"]["tp"][node.chef_environment.to_s]["war_url"]
#    checksum node["lp2"]["tp"][node.chef_environment.to_s]["war_checksum"]
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
