#
# Cookbook Name:: oeinfra
# Recipe:: autohome
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
#
env = node.chef_environment.to_s.split("-").last

package "nfs-common" do
  action :install
end

package "autofs" do
  action :install
end

directory "/export" do
  action :create
  user "root"
  group "root"
  mode "755"
end

directory "/export/home" do
  action :create
  user "root"
  group "root"
  mode "755"
end

cookbook_file "/etc/auto.master" do
  action :create
  source "autohome/auto.master"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, 'service[autofs]', :delayed
end

template "/etc/auto.home" do
  action :create
  source "autohome/auto.home.erb"
  owner "root"
  group "root"
  mode "0640"
  variables ({
    :nfsserver => node[:oeinfra][node.chef_environment.to_s.split("-").last]['nfs']  
  })
  notifies :reload, 'service[autofs]', :delayed
end

service "autofs" do
  action [ :start, :enable ]
end

