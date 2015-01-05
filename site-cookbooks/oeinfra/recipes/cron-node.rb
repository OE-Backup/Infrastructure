#
# Cookbook Name:: oeinfra
# Recipe:: cron-node
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#

include_recipe "oeinfra::cron-node-requirements"

#
# cron job to do daily backups for chef server
#

backup_scripts_path = '/opt/backup-scripts'

directory node['oeinfra']['cron-node']['backup_scripts_path']

oeinfra_settings = Chef::DataBagItem.load('oeinfra', 'settings')
oeinfra_secrets = Chef::EncryptedDataBagItem.load('oeinfra', 'secrets')

template "#{node['oeinfra']['cron-node']['backup_scripts_path']}/manage_snapshots.py" do
  action            :create
  owner             'root'
  group             'root'
  mode              '0755'
  source            'cron-node/manage_snapshots.py.erb'
  variables({
    :aws_access_key => oeinfra_settings['cron-node']['aws']['s3']['access_key_id'],
    :aws_secret_key =>  oeinfra_secrets['cron-node']['aws']['s3']['secret_access_key']
  })
end

template '/etc/cron.daily/backup-chef-v11-server' do
  action           :create
  owner            'root'
  group            'root'
  mode             '0755'
  source           'cron-node/manage_snapshots_wrapper.sh.erb'
  variables({
    :volume_id     => node['oeinfra']['backups']['chef11']['server_volume_id'],
    :num_snapshots => node['oeinfra']['backups']['chef11']['num_snapshots_to_keep'],
    :subject       => 'backup chef11 daily snapshots status',
    :from          => 'infrastructure@openenglish.com',
    :to            => 'notifications@openenglish.com'
  })
end

template '/etc/cron.daily/backup-prd-pp2-chef-master' do
  action           :create
  owner            'root'
  group            'root'
  mode             '0755'
  source           'cron-node/manage_snapshots_wrapper.sh.erb'
  variables({
    :volume_id     => node['oeinfra']['backups']['prd-pp2-chef-master']['server_volume_id'],
    :num_snapshots => node['oeinfra']['backups']['prd-pp2-chef-master']['num_snapshots_to_keep'],
    :subject       => 'backup prd-pp2-chef-master daily snapshots status',
    :from          => 'infrastructure@openenglish.com',
    :to            => 'notifications@openenglish.com'
  })
end

template '/etc/cron.daily/backup-prd-pp2-banorte-master' do
  action           :create
  owner            'root'
  group            'root'
  mode             '0755'
  source           'cron-node/manage_snapshots_wrapper.sh.erb'
  variables({
    :volume_id     => node['oeinfra']['backups']['prd-pp2-banorte-master']['server_volume_id'],
    :num_snapshots => node['oeinfra']['backups']['prd-pp2-banorte-master']['num_snapshots_to_keep'],
    :subject       => 'backup prd-pp2-banorte-master daily snapshots status',
    :from          => 'infrastructure@openenglish.com',
    :to            => 'notifications@openenglish.com'
  })
end

template '/etc/cron.daily/backup-spotfirewp-server' do
  action           :create
  owner            'root'
  group            'root'
  mode             '0755'
  source           'cron-node/manage_snapshots_wrapper.sh.erb'
  variables({
    :volume_id     => node['oeinfra']['backups']['spotfirewp']['server_volume_id'],
    :num_snapshots => node['oeinfra']['backups']['spotfirewp']['num_snapshots_to_keep'],
    :subject       => 'backup spotfirewp snapshots status',
    :from          => 'infrastructure@openenglish.com',
    :to            => 'notifications@openenglish.com'
  })
end

template '/etc/cron.daily/backup-spotfire-server' do
  action           :create
  owner            'root'
  group            'root'
  mode             '0755'
  source           'cron-node/manage_snapshots_wrapper.sh.erb'
  variables({
    :volume_id     => node['oeinfra']['backups']['spotfire']['server_volume_id'],
    :num_snapshots => node['oeinfra']['backups']['spotfire']['num_snapshots_to_keep'],
    :subject       => 'backup spotfire snapshots status',
    :from          => 'infrastructure@openenglish.com',
    :to            => 'notifications@openenglish.com'
  })
end

template '/etc/cron.weekly/backup-prd-infosec-ad-master' do
  action           :create
  owner            'root'
  group            'root'
  mode             '0755'
  source           'cron-node/manage_snapshots_wrapper.sh.erb'
  variables({
    :volume_id     => node['oeinfra']['backups']['prd-infosec-ad-master']['server_volume_id'],
    :num_snapshots => node['oeinfra']['backups']['prd-infosec-ad-master']['num_snapshots_to_keep'],
    :subject       => 'backup prd-infosec-ad-master snapshots status',
    :from          => 'infrastructure@openenglish.com',
    :to            => 'notifications@openenglish.com'
  })
end

# insert new cron task here
#
