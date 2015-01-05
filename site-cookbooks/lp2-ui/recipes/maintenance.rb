#
# Cookbook Name:: lp2-ui
# Recipe:: maintenance
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "lp2-ui::apache"

ui_settings = Chef::DataBagItem.load("lp2", "settings")

template "#{node['apache']['dir']}/sites-available/maintenance" do
  owner "root"
  group "root"
  mode "0644"
  source "maintenance.vhost.erb"
  variables({
    :domain => node['lp2']['domain'],
    :server_name => ui_settings[node.chef_environment]['ui']['apache']['server_name'],
    :server_alias => node['lp2']['domain']
  })
end

directory "#{node['apache']['docroot_dir']}/maintenance"

%w(maintenance.jpg index.html).each do |maint_file|
  cookbook_file "#{node['apache']['docroot_dir']}/maintenance/#{maint_file}" do
    owner "root"
    group "root"
    mode "0644"
  end
end

%w(ui ui-ssl).each do |vhost|
  execute "disable-site-#{vhost}" do
    command "a2dissite #{vhost}"
    user "root"
    group "root"
  end
end

execute "enable-site-maintenance" do
  command "a2ensite maintenance"
  user "root"
  group "root"
end

# Start apache2 service
service "apache2" do
  action :restart
end
