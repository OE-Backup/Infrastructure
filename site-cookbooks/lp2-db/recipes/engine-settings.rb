#
# Cookbook Name:: lp2-db
# Recipe:: engine-settings
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute

# I thought these attributes should be defined at role level but
# the only way I could avoid the installation of PostgreSQL 9.3 was
# setting them here in the recipe at normal level!
node.set['postgresql']['client']['packages']  = %w{postgresql-client-9.2 libpq-dev}
node.set['postgresql']['server']['packages']  = %w{postgresql-9.2}
node.set['postgresql']['contrib']['packages'] = %w{postgresql-contrib-9.2}

# wal settings
node.set['lp2']['db']['postgresql']['config']['wal_path'] = '/mnt/postgresql/archived_wal'
node.set['lp2']['db']['postgresql']['config']['wal_bucket'] = 's3://openenglish-backup'
node.set['lp2']['db']['postgresql']['config']['wal_s3_path'] = \
  "#{node['lp2']['db']['postgresql']['config']['wal_bucket']}" \
  + "/#{node.chef_environment.to_s}/postgresql-#{node['postgresql']['version']}/archived_wal/"

# archiving feature
node.set['postgresql']['config']['archive_command'] = \
  "test ! -f #{node['lp2']['db']['postgresql']['config']['wal_path']}/%f && \
  cp %p #{node['lp2']['db']['postgresql']['config']['wal_path']}/%f && \
  s3cmd put #{node['lp2']['db']['postgresql']['config']['wal_path']}/%f \
  #{node['lp2']['db']['postgresql']['config']['wal_s3_path']}"

# backup path in s3
node.set['lp2']['db']['postgresql']['config']['backup_s3_path'] = \
  "#{node['lp2']['db']['postgresql']['config']['wal_bucket']}" \
  + "/#{node.chef_environment.to_s}/postgresql-#{node['postgresql']['version']}/"
