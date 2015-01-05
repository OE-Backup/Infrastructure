#
# Cookbook Name:: lp2-easydita
# Recipe:: tomcat
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
# EasyDITA webapp uses tomcat as backend application server
include_recipe "tomcat::default"
include_recipe "tomcat::users"
require 'digest/md5'
require 'fileutils'

lp2_settings = Chef::DataBagItem.load("lp2", "settings")
lp2_secrets = Chef::EncryptedDataBagItem.load("lp2", "secrets")

#Create necessary folders & subfolders
directory "/opt/env_variables" do
  owner "tomcat6"
  group "tomcat6"
  mode "755"
  action :create
end

directory "/var/log/easydita" do
  owner "tomcat6"
  group "tomcat6"
  mode "755"
  action :create
end

%w{originals originals_not processed}.each do |dir|
  directory "/opt/env_variables/#{dir}" do
    mode "755"
    owner "tomcat6"
    group "tomcat6"
    action :create
    recursive true
  end
end

file "/var/log/easydita/easydita.log" do
  owner "tomcat6"
  group "tomcat6"
  mode "664"
  action :create
end

#Populates files from templates
template "/opt/env_variables/easyditaCredentials.properties" do
  source "easyditaCredentials.properties.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
  variables({
    :amazon_service_keyid => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["amazon_service_keyid"],
    :amazon_service_secret => lp2_secrets[node.chef_environment.to_s]["easydita"]["amazon_service_secret"],
    :amazon_bucket_name => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["amazon_bucket_name"],
    :amazon_bucket_url => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["amazon_bucket_url"],
    :ftp_host => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["ftp_host"],
    :ftp_username => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["ftp_username"],
    :ftp_password => lp2_secrets[node.chef_environment.to_s]["easydita"]["ftp_password"],
    :easydita_stage_username => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["easydita_stage_username"],
    :easydita_stage_password => lp2_secrets[node.chef_environment.to_s]["easydita"]["easydita_stage_password"],
    :easydita_production_username => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["easydita_production_username"],
    :easydita_production_password => lp2_secrets[node.chef_environment.to_s]["easydita"]["easydita_production_password"],
    :mail_auth => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["mail_auth"],
    :mail_pass => lp2_secrets[node.chef_environment.to_s]["easydita"]["mail_pass"],
    :mail_host => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["mail_host"],
    :mail_port => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["mail_port"],
    :mail_starttls => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["mail_starttls"],
    :mail_user => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaCredentials"]["mail_user"]
  })
end

template "/opt/env_variables/easyditaDatabase.properties" do
  source "easyditaDatabase.properties.erb"
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
  variables({
    :jdbc_driverClassName => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaDatabase"]["jdbc_driverClassName"],
    :jdbc_databaseurl  => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaDatabase"]["jdbc_databaseurl"],
    :jdbc_username  => lp2_settings[node.chef_environment.to_s]["easydita"]["easyditaDatabase"]["jdbc_username"],
    :jdbc_password => lp2_secrets[node.chef_environment.to_s]["easydita"]["jdbc_password"]
  })
end

cookbook_file "/opt/env_variables/easyditaUploader.properties" do
  owner "tomcat6"
  group "tomcat6"
  mode "0644"
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

default_index_file = "#{node["tomcat"]["webapp_dir"]}/ROOT/index.html"
default_index_checksum = lp2_settings[node.chef_environment]["easydita"]["tomcat"]["default_index_checksum"]

# undeploy default Debian ROOT context
#ruby_block "undeploy-debian-root-context" do
#  only_if { File.exists?(default_index_file) }
#  block do
#    if Digest::MD5.hexdigest(File.read(default_index_file)).eql?(default_index_checksum)
#      FileUtils.rm_rf "#{node["tomcat"]["webapp_dir"]}/ROOT"
#    end
#  end
#end

#if node["lp2"]["easydita"][node.chef_environment.to_s]["war_url"]
#  remote_file "#{node["tomcat"]["webapp_dir"]}/ROOT.war" do
#    owner node["tomcat"]["user"]
#    group node["tomcat"]["group"]
#    mode 0644
#    source node["lp2"]["easydita"][node.chef_environment.to_s]["war_url"]
#    checksum node["lp2"]["easydita"][node.chef_environment.to_s]["war_checksum"]
#  end
#end

cookbook_file "/etc/logrotate.d/tomcat6" do
  owner "root"
  group "root"
  mode "0644"
  source "logrotate_tomcat6"
end

# dedicated log file for the jvm
file "#{node["tomcat"]["log_dir"]}/jvm.log" do
  action :touch
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
end
