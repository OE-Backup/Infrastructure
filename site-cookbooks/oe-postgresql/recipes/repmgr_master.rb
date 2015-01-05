#
# Cookbook Name:: oe-postgresql
# Recipe:: repmgr
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

include_recipe 'oe-postgresql::repmgr'

return unless node['postgresql']['server']['replication']

########################################################
## << This code is only executed on the master server >>

execute 'repmgr-create-db' do
  action    :run
  user      node['postgresql']['user']['name']
  command <<-EOC
    echo 'CREATE DATABASE repmgr WITH OWNER #{node['repmgr']['db']['user']};' | psql
  EOC
  not_if "echo \"\
      SELECT datname \
        FROM pg_database \
        WHERE datname = 'repmgr';\" |\
    psql -t |\
    grep 'repmgr'", :user => node['postgresql']['user']['name']
end

execute 'repmgr-sqlfuncs' do
  action    :run
  user      node['postgresql']['user']['name']
  command <<-EOC
    psql <#{node['postgresql']['prefix']['scripts_sql']}/repmgr_funcs.sql
  EOC
end

execute 'repmgr-init' do
  action  :run
  user    node['postgresql']['user']['name']
  command <<-EOC
    #{node['postgresql']['prefix']['install']}/bin/repmgr \
      -f #{node['postgresql']['prefix']['cfg']}/repmgr.conf \
      --verbose \
      master register \
      >#{node['postgresql']['prefix']['log']}/repmgr.log 2>&1
  EOC
  not_if "echo '\
      SELECT COUNT(*) \
        FROM repmgr_#{node['repmgr']['config']['cluster']}.repl_nodes \
        WHERE id = #{node['repmgr']['config']['node']};' |\
    psql -td repmgr |\
    awk '/[1-9]$/'  |\
    grep '1'", :user => node['postgresql']['user']['name']
end

