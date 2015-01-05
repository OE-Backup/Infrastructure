#
# Cookbook Name:: lp2-lcs
# Recipe:: sfdcmetrics-cron
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
require 'uri'

%w(/ /tool /zips).each do |dir|
  directory "#{node['lp2']['sfdcmetrics']['path']}#{dir}" do
    owner  node['lp2']['sfdcmetrics']['owner']
    group  node['lp2']['sfdcmetrics']['group']
    mode   0755
  end
end

sfdcmetrics_uri = URI.parse(node['lp2']['sfdcmetrics'][node.chef_environment]['zip_url'])

#remote_file "#{node['lp2']['sfdcmetrics']['path']}/#{File.basename(sfdcmetrics_uri.path)}" do
#  action    :create
#  owner     node['lp2']['sfdcmetrics']['owner']
#  group     node['lp2']['sfdcmetrics']['group']
#  mode      0644
#  source    node['lp2']['sfdcmetrics'][node.chef_environment]['zip_url']
#  checksum  node['lp2']['sfdcmetrics'][node.chef_environment]['zip_checksum']
#end

template "#{node['lp2']['sfdcmetrics']['path']}/README_sfdcmetrics.txt" do
  owner node['lp2']['sfdcmetrics']['owner']
  group node['lp2']['sfdcmetrics']['group']
  mode  0644
end

template "/etc/cron.hourly/sfdcmetrics" do
  owner "root"
  group "root"
  mode  0755
end
