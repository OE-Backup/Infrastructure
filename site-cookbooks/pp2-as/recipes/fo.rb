#
# Cookbook Name:: pp2-as
# Recipe:: fo.rb 
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute
#

directory "#{node['fo']['dir']}" do
  owner "root"
  group "root"
  mode "0644"
  action :create
  recursive true
end


%w(mail_app_not_running_in_master.py mail_app_not_running.py mail_app_running.py promote_as_slave.sh).each do |file|
   cookbook_file "#{node['fo']['dir']}/#{file}" do
   source "fo-#{node.chef_environment.to_s.split("-").last}/#{file}"	
   mode 0755
   owner "root"
   group "root"
 end
end

file "/etc/cron.d/fo" do
  owner "root"
  group "root"
  mode "644"
  content "#*/5 *   * * * 	root sh /opt/fo/promote_as_slave.sh"
end

