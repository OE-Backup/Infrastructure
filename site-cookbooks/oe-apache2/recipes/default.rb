#
# Cookbook Name:: oe-apache2
# Recipe:: default 
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2::default"
include_recipe "apache2::mod_proxy_ajp"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_status"


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
  file "#{node['apache']['dir']}/sites-conf/default/ssl/wildcard.#{node['ssl']['fqdn']}.#{pem}" do
    owner "root"
    group "root"
    case pem
    when "ca"
      content "#{node['apache']['ssl']['chaincert']}"
      mode "0644"
    when "crt"
      content "#{node['apache']['ssl']['cert']}"
      mode "0644"
    when "key"
      content "#{node['apache']['ssl']['key']}"
      mode "0400"
    else
    end
  end
end

# Disable default vhost
apache_site "000-default" do
  enable false
end


template "/etc/apache2/ports.conf" do
  source "ports.conf.erb"
  user "root"
  group "root"
  mode "0644"
  notifies :restart,'service[apache2]', :delayed
end


service "apache2" do
  supports :status => true, :restart => true, :stop => false, :start => true
  action :nothing
end

