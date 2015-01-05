#
# Cookbook Name:: oeinfra
# Recipe:: ldapauth
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ENV['DEBIAN_FRONTEND'] = 'noninteractive'

%w{ nscd libnss-ldap }.each { |pkg|
  package pkg do
    action :install
  end
}

service 'ssh' do
  action [ :start, :enable ]
end

service 'nscd' do
  action [ :start, :enable ]
end

cookbook_file '/etc/ssh/sshd_config' do
  source 'ldapauth/sshd_config'
  owner 'root'
  group 'root'
  mode '0640'
  action :create
  notifies  :restart, "service[ssh]", :delayed
end

cookbook_file '/etc/nsswitch.conf' do
  action :create
  source 'ldapauth/nsswitch.conf'
  owner 'root'
  group 'root'
  mode '0644'
  notifies  :restart, "service[nscd]", :delayed
end

template '/etc/ldap.conf' do
  action :create
  source 'ldapauth/ldap.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  backup 1
end

cookbook_file '/etc/pam.d/sshd' do
  action :create
  source 'ldapauth/sshd'
  owner 'root'
  group 'root'
  mode '0440'
  backup 1
end

cookbook_file '/etc/pam.d/common-session' do
  action :create
  source 'ldapauth/common-session'
  owner 'root'
  group 'root'
  mode '0644'
  backup 1
end

cookbook_file '/etc/sudoers' do
  action :create
  source 'ldapauth/sudoers'
  owner 'root'
  group 'root'
  mode '0440'
  backup 1
end

cookbook_file '/etc/sudoers.d/80-sudoers-ldap' do
  action :create
  source "ldapauth/#{node['oeinfra'][node.chef_environment.to_s.split('-').last]['sudoers']}"
  owner 'root'
  group 'root'
  mode '0440'
end

cookbook_file '/etc/sudoers.d/90-cloudimg-ubuntu' do
  source 'ldapauth/90-cloudimg-ubuntu'
  owner 'root'
  group 'root'
  mode '0440'
  action :create
end

# Miguel to-do: fix this
# User ubuntu it's not guaranteed to exists in every server...
group 'adm' do
  only_if 'grep "^ubuntu:" /etc/passwd'
  action :modify
  append true
  members 'ubuntu'
end

include_recipe 'oeinfra::access_groups'

