#
# Cookbook Name:: lp2-db
# Recipe:: postgres-user
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute

node.set['lp2']['db']['postgresql']['homedir'] = '/var/lib/postgresql'

# dba team prefers to operate the db servers this way
execute 'copy-postgresql-conf-to-postgres-homedir' do
  user     'root'
  group    'root'
  command  "rsync -avP #{node['postgresql']['dir']}/postgresql.conf \
    #{node['lp2']['db']['postgresql']['homedir']}/#{node['postgresql']['version']}/main"
end

%w(
  pg_dump
  log/checklist_files/sabado
  log/checklist_files/domingo
  log/backups
  log/tmp
  archived_wal
).each do |subdir|
  directory "/mnt/postgresql/#{subdir}" do
    owner      'postgres'
    group      'postgres'
    mode       0755
    recursive  true
  end
end

%w(
  postgresql
  postgresql_b
).each do |subdir|
  directory "/mnt/backups/#{subdir}" do
    owner      'postgres'
    group      'postgres'
    mode       0755
    recursive  true
  end
end
 
execute 'apply-postgres-permission' do
  user     'root'
  group    'root'
  command  'chown postgres:postgres -R /mnt/postgresql /mnt/backups'
end

cron 'autopostgresql.sh' do
  action   :create
  action   node['lp2']['db']['master?'] ? :create : :delete
  user     'postgres'
  minute   '20'
  hour     '7'
  command  "#{node['lp2']['db']['postgresql']['homedir']}/scripts/autopostgresqlbackup.sh"
end

cron 'autopostgresql_b.sh' do
  action   :create
  action   node['lp2']['db']['master?'] ? :create : :delete
  user     'postgres'
  minute   '50'
  hour     '7'
  command  "#{node['lp2']['db']['postgresql']['homedir']}/scripts/autopostgresqlbackup_b.sh"
end

cron 'reporte_checklist_diario_lp20_prod.sh' do
  action    :create
  action    node['lp2']['db']['master?'] ? :create : :delete
  user     'postgres'
  minute   '0'
  hour     '10'
  command  "#{node['lp2']['db']['postgresql']['homedir']}/scripts/reporte_checklist_diario_lp20_prod.sh"
end

directory "#{node['lp2']['db']['postgresql']['homedir']}/scripts" do
  owner  'postgres'
  group  'postgres'
  mode   0750
end

%w(
  limpia_alertinfra1.sh
  reporte_checklist_diario_lp20_prod.sh
  duplicate_address.sh
  studentcleanup.sql
  duplicate_address.sql
).each do |script|
  cookbook_file "#{node['lp2']['db']['postgresql']['homedir']}/scripts/#{script}" do
    owner   'postgres'
    group   'postgres'
    mode    0750
    source  "scripts/#{script}"
  end
end

%w(
  autopostgresqlbackup.sh
  autopostgresqlbackup_b.sh
  s3sync.sh
).each do |script|
  template "#{node['lp2']['db']['postgresql']['homedir']}/scripts/#{script}" do
    owner   'postgres'
    group   'postgres'
    mode    0755
    source  "scripts/#{script}.erb"
  end
end

package 'python-pip'

execute 'install-cli53' do
  user     'root'
  group    'root'
  command  'pip install cli53'
end

lp2_settings = Chef::DataBagItem.load('lp2', 'settings')
lp2_secrets = Chef::EncryptedDataBagItem.load('lp2', 'secrets')

node.set['lp2']['db']['route53']['aws_access_key_id'] = lp2_settings[node.chef_environment.to_s]['db']['route53_access_key_id']
node.set['lp2']['db']['route53']['aws_secret_access_key'] = lp2_secrets[node.chef_environment.to_s]['db']['route53_secret_access_key']
node.set['lp2']['db']['postgresql']['repmgr']['password'] = lp2_secrets[node.chef_environment.to_s]['db']['repmgr_password']
node.set['lp2']['db']['s3']['aws_access_key_id'] = lp2_settings[node.chef_environment.to_s]['db']['s3_access_key_id']
node.set['lp2']['db']['s3']['aws_secret_access_key'] = lp2_secrets[node.chef_environment.to_s]['db']['s3_secret_access_key']

# search all db nodes in the cluster
db_nodes = search(:node, "chef_environment:#{node.chef_environment.to_s} AND role:db-lp2-node")

%w(
  profile
  boto
  pgpass
  s3cfg
).each do |dotfile|
  template "#{node['lp2']['db']['postgresql']['homedir']}/.#{dotfile}" do
    owner       'postgres'
    group       'postgres'
    mode        0600
    source      "dotfiles/#{dotfile}.erb"
    variables({
      :db_nodes => db_nodes
    })
  end
end

# ssh configuration for postgres user
# this allows to work repmgr replication transparently

directory "#{node['lp2']['db']['postgresql']['homedir']}/.ssh" do
  owner 'postgres'
  group 'postgres'
  mode  0700
end

file "#{node['lp2']['db']['postgresql']['homedir']}/.ssh/known_hosts" do
  owner   'postgres'
  group   'postgres'
  mode    0600
  action  :touch
end

execute 'create-ssh-keypar-for-postgres-user' do
  creates  "#{node['lp2']['db']['postgresql']['homedir']}/.ssh/id_rsa"
  user     'postgres'
  group    'postgres'
  cwd      node['lp2']['db']['postgresql']['homedir']
  command  'ssh-keygen -q -b 4096 -t rsa -N "" -f .ssh/id_rsa'
end

ruby_block 'copy-postgres-ssh-public-key' do
  block do
    postgres_ssh_pub_key_path = "#{node['lp2']['db']['postgresql']['homedir']}/.ssh/id_rsa.pub"
    if File.exists?(postgres_ssh_pub_key_path)
      node.set['lp2']['db']['postgresql']['ssh_public_key'] = \
        File.read(postgres_ssh_pub_key_path)
    end
  end
end

template "#{node['lp2']['db']['postgresql']['homedir']}/.ssh/authorized_keys" do
  ignore_failure  true
  owner           'postgres'
  group           'postgres'
  mode            0600
  source          'dotfiles/authorized_keys.erb'
  variables({
    :db_nodes => db_nodes
  })
end

ruby_block 'populate-postgres-ssh-known-hosts-file' do
  block do
    db_nodes.each do |dbnode|
      system("ssh-keyscan -t rsa #{dbnode['ipaddress']} 2>&1 | \
              sort -u - #{node['lp2']['db']['postgresql']['homedir']}/.ssh/known_hosts \
              > #{Chef::Config[:file_cache_path]}/tmp_known_hosts")
      system("cat #{Chef::Config[:file_cache_path]}/tmp_known_hosts \
              > #{node['lp2']['db']['postgresql']['homedir']}/.ssh/known_hosts")
      File.delete("#{Chef::Config[:file_cache_path]}/tmp_known_hosts")
    end
  end
end

ruby_block 'display-postgres-ssh-known-hosts-file' do
  block do
    puts File.read("#{node['lp2']['db']['postgresql']['homedir']}/.ssh/known_hosts")
  end
end
