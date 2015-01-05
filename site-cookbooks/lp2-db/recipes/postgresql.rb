#
# Cookbook Name:: lp2-db
# Recipe:: engine-settings
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute

include_recipe 'postgresql::server'

template '/etc/sysctl.d/30-postgresql-shm.conf' do
  owner     'root'
  group     'root'
  mode      0644
  notifies  :run, 'execute[reload-shm-settings]', :immediately
  source    'os/30-postgresql-shm.conf.erb'
end

execute 'reload-shm-settings' do
  action    :nothing
  user      'root'
  group     'root'
  command  'sysctl -p /etc/sysctl.d/30-postgresql-shm.conf'
end
