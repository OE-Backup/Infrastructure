#
# Cookbook Name:: lp2-db
# Recipe:: repmgr
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute

%w{s3cmd repmgr postgresql-9.2-repmgr}.each do |pkg|
  package pkg
end

directory "#{node['lp2']['db']['postgresql']['homedir']}/repmgr" do
  owner  "postgres"
  group  "postgres"
  mode   0755
end

%w(promote.sh follow.sh repmgr.conf).each do |repconf|
  template "#{node['lp2']['db']['postgresql']['homedir']}/repmgr/#{repconf}" do
    owner   'postgres'
    group   'postgres'
    mode    repconf.match(/\.sh$/) ? 0755 : 0644
    source  "repmgr/#{repconf}.erb"
  end
end

# create user and db needed for repmgr operation
# it also install repmgr functions on that db
execute "create-repmgr-db-role" do
  not_if   "psql -c '\\dg' | grep -c repmgr", :user => 'postgres'
  user     'postgres'
  group    'postgres'
  command  'createuser --login --superuser -e repmgr'
  notifies  :run, 'execute[set-repmgr-db-role-password]', :immediately
end

execute "set-repmgr-db-role-password" do
  action   :nothing
  user     'postgres'
  group    'postgres'
  command  "psql -c \"ALTER USER repmgr WITH PASSWORD '#{node['lp2']['db']['postgresql']['repmgr']['password']}';\""
end

execute "create-repmgr-db" do
  not_if   "psql -c '\\l' | grep -c repmgr", :user => 'postgres'
  user     'postgres'
  group    'postgres'
  command  'createdb -O repmgr repmgr'
end

execute "install-repmgr-funcs" do
  not_if   "psql -d repmgr -c '\\sf repmgr_update_standby_location'", :user => 'postgres'
  user     'postgres'
  group    'postgres'
  command  "psql -f /usr/share/postgresql/#{node['postgresql']['version']}/contrib/repmgr_funcs.sql repmgr"
end

# there are some issues/gotchas here:
# 1. this restart is needed because postgresql cookbook only trigger a reloads on
#    service[postgresql] but there are settings that need a restart.
# 2. resource execute is used instead of service because I couldn't figure why a service :restart fails.
# 3. execute resource has an attribute called path but it doesn't work, see ticket CHEF-2082 in Chef JIRA.
# 4. Due to 3, I have to pass the PATH variable through direct environment variables manipulation.
execute "restart-postgresql-with-pgctl" do
  action      :nothing
  user        'postgres'
  group       'postgres'
  cwd         node['lp2']['db']['postgresql']['homedir']
  env         ({ 'PATH' => "/usr/lib/postgresql/#{node['postgresql']['version']}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin" })
  command     "pg_ctl -w restart -D #{node['postgresql']['config']['data_directory']}"
  subscribes  :run, "template[#{node['postgresql']['dir']}/postgresql.conf]", :delayed
end
