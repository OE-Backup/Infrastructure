#
# Cookbook Name:: oe-infosec
# Recipe:: auditd
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute
#
%w{libaudit0 auditd}.each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file "/etc/audit/auditd.conf" do
  source "auditd.conf"
  mode "0640"
  owner "root"
  group "root"
  action :create
  notifies :restart, "service[auditd]", :immediate
end

cookbook_file "/etc/audit/audit.rules" do
  source "audit.rules"
  mode "0640"
  owner "root"
  group "root"
  action :create
  notifies :restart, "service[auditd]", :immediate
end

service "auditd" do
  action [ :enable, :start ]
end

directory "/opt/oe-infosec/" do
  owner "root"
  group "root"
  mode "0700"
  action :create
end

cookbook_file "/opt/oe-infosec/aparser.py" do
  source "aparser.py"
  mode "0740"
  owner "root"
  group "root"
  action :create
end

directory "/var/log/audit/" do
  owner "syslog"
  group "syslog"
  mode "0644"
  recursive
  action :create
  notifies :restart, "service[auditd]", :immediate
end

file "/var/log/audit/audit.log" do
  owner "syslog"
  group "syslog"
  mode "0644"
  action :create
  notifies :restart, "service[auditd]", :immediate
end

#cookbook_file "/etc/cron.d/aparser.cron" do
#  source "aparser.cron"
#  mode "0740"
#  owner "root"
#  group "root"
#  action :create
#end
