#
# Cookbook Name:: salesforce 
# Recipe:: apache
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'oe-apache2::default'

# Setup plain and SSL virtual hosts
%w(salesforce salesforce-ssl).each do |vhost|
  template "#{node['apache']['dir']}/sites-available/#{vhost}" do
    owner "root"
    group "root"
    mode "0644"
    source "#{File.basename(vhost)}.vhost.erb"
  end
end


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


service "apache2" do
  supports :status => true, :restart => true, :stop => false, :start => true
  action :nothing
end

