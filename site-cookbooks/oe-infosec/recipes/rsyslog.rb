#
# Cookbook Name:: oe-infosec
# Recipe:: rsyslog
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute
#
service "rsyslog"

cookbook_file "/etc/logrotate.d/auditron" do
  source "auditron"
  mode "0644"
  owner "root"
  group "root"
  action :create
  notifies :restart, "service[rsyslog]", :immediate
end

template "/etc/rsyslog.d/10-infosec_syslog.conf" do
  source "10-infosec_syslog.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  action :create
  notifies :restart, "service[rsyslog]", :immediate
end
