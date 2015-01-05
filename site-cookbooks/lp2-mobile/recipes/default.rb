#
# Cookbook Name:: lp2-mobile
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# lp2-api debian package expects to have OE_ENV enviroment variable set
file '/etc/profile.d/lp2-environment.sh' do
  owner   'root'
  group   'root'
  mode    '0755'
  content "OE_ENV=#{node.chef_environment.split('-').last}"
end
