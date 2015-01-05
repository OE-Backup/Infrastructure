#
# Cookbook Name:: lp2-comm
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "oe-tomcat::default"

directory "/var/log/lp2" do
  owner node["tomcat"]["user"]
  group "adm"
  mode 00750
  action :create
end

file "/var/log/lp2/chat.log" do
  owner node["tomcat"]["user"]
  group "adm"
  mode 00644
  action :create
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
    :jdbc_user       => lp2_settings[node.chef_environment.to_s]["comm"]["jdbc_user"],
    :jdbc_pass       =>  lp2_secrets[node.chef_environment.to_s]["comm"]["jdbc_pass"],
    :jdbc_url        => lp2_settings[node.chef_environment.to_s]["comm"]["jdbc_url"],
    :memcached_nodes => lp2_settings[node.chef_environment.to_s]["comm"]["memcached_nodes"]
  })
end
