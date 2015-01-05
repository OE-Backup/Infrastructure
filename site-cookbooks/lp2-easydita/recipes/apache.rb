#
# Cookbook Name:: lp2-easydita
# Recipe:: apache
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
# EasyDITA webapp uses apache2 default feature set plus some modules
include_recipe "apache2::default"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_proxy_ajp"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_status"

# Setup plain and SSL virtual hosts
%w(easydita easydita-ssl).each do |vhost|
  template "#{node['apache']['dir']}/sites-available/#{vhost}" do
    owner "root"
    group "root"
    mode "0644"
    source "#{File.basename(vhost)}.vhost.erb"
    variables({ :domain => node['lp2']['domain'] })
  end
end

# Load need PEM files for SSL setup from data bags
easydita_ssl_info = Chef::DataBagItem.load("lp2", "ssl")
easydita_secrets = Chef::EncryptedDataBagItem.load("lp2", "secrets")

directory "#{node['apache']['dir']}/sites-conf/default/ssl" do
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

# Generic root content directory configuration
cookbook_file "#{node['apache']['dir']}/sites-conf/default/rootdir.conf" do
  owner "root"
  group "root"
  mode "0644"
end

# Setup SSL PEM files
%w(ca crt key).each do |pem|
  file "#{node['apache']['dir']}/sites-conf/default/ssl/wildcard.#{node['lp2']['domain']}.#{pem}" do
    owner "root"
    group "root"
    case pem
    when "ca"
      content easydita_ssl_info[node.chef_environment]['chainfile']
      mode "0644"
    when "crt"
      content easydita_ssl_info[node.chef_environment]['wildcard_cert']
      mode "0644"
    when "key"
      content easydita_secrets[node.chef_environment]['wildcard_key']
      mode "0400"
    else
    end
  end
end

# Enable EasyDITA virtual hosts
%w(easydita easydita-ssl).each do |vhost|
  apache_site vhost do
    enable true
    action :nothing
    subscribes :run, "template[#{node['apache']['dir']}/sites-available/#{vhost}]", :immediately
  end
end

# Disable default vhost
apache_site "000-default" do
  enable false
end

if node['lp2']['maintenance_mode']
  include_recipe "lp2-easydita::maintenance"
else
  execute "disable-site-maintenance" do
    command "a2dissite maintenance"
    user "root"
    group "root"
    ignore_failure true
  end
end

cookbook_file "/etc/apache2/mods-available/proxy.conf" do
  owner "root"
  group "root"
  mode "0644"
  source "proxy.conf"
end

cookbook_file "/etc/logrotate.d/apache2" do
  owner "root"
  group "root"
  mode "0644"
  source "logrotate_apache2"
end

# Start apache2 service
service "apache2" do
  action :restart
end
