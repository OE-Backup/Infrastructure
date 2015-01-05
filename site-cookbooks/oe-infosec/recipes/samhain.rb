#
# Cookbook Name:: oe-infosec
# Recipe:: samhain
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#

#package "samhain" do
#  action :install
#end

#package "libaudit0" do
#  action :install
#end

service "rsyslog"
service "samhain"

remote_file "/tmp/samhain.deb" do
  source "#{node['oe-infosec']['samhain']['URL']}"
  mode "0644"
  checksum "4563e01dac5f8b6b114f5eae23e880a18c8e62f5bb280414e9f3a3aaa19c7ca6"
end

dpkg_package "samhain" do
  source "/tmp/samhain.deb"
  action :install
end

file "/etc/rsyslog.d/90-samhain.conf" do
  owner "root"
  group "root"
  mode "0644"
  content "local7.* /var/log/samhain.log"
  notifies :restart, "service[rsyslog]", :immediate
end

file "/var/log/samhain.log" do
  owner "syslog"
  group "adm"
  mode "0640"
  action :create_if_missing
  notifies :restart, "service[samhain]", :immediate
end
