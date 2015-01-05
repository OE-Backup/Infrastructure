#
# Cookbook Name:: pp2-store2
# Recipe:: apache
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
# Store2 Webapp uses apache2 default feature set plus some modules
include_recipe "apache2::default"
include_recipe "apache2::mod_proxy_ajp"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_status"

# Setup plain and SSL virtual hosts
%w(store2 store2-ssl).each do |vhost|
  template "#{node['apache']['dir']}/sites-available/#{vhost}" do
    owner "root"
    group "root"
    mode "0644"
    source "#{File.basename(vhost)}.vhost.erb"
    variables({ :domain => node['pp2']['domain'] })
  end
end

# Load need PEM files for SSL setup from data bags
store_ssl_domain = node["store2"][node.chef_environment]["ssl_domain"]
store_ssl_info = Chef::DataBagItem.load("ssl", store_ssl_domain)
store_secrets = Chef::EncryptedDataBagItem.load("ssl-keys", store_ssl_domain)

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
  file "#{node['apache']['dir']}/sites-conf/default/ssl/wildcard.#{node['pp2']['domain']}.#{pem}" do
    owner "root"
    group "root"
    case pem
    when "ca"
      content store_ssl_info['chaincert']
      mode "0644"
    when "crt"
      content store_ssl_info['cert']
      mode "0644"
    when "key"
      content store_secrets['key']
      mode "0400"
    else
    end
  end
end

# Enable Store2 virtual hosts
%w(store2 store2-ssl).each do |vhost|
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
