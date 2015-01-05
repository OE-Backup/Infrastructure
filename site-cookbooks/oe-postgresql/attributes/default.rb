#
# Cookbook Name:: oe-postgresql
# Attribute:: default
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

default['postgresql']['version'] = '9.2'

# Packages required. Version is appended
default['postgresql']['server']['packages'] = %w{ postgresql postgresql-contrib }
default['postgresql']['client']['packages'] = %w{ postgresql-client }

default['postgresql']['user'] = {
  'name'  => 'postgres',
  'home'  => '/var/lib/postgresql',
  'gecos' => 'PostgreSQL user',
  'shell' => '/bin/bash'
}

default['postgresql']['group'] = {
  'name' => 'postgres',
}

# Databag and Databag Item containing users
# data_bag_item should be explicitly set in role / environment
default['postgresql']['databag']      = 'db_users'
default['postgresql']['databag_item'] = nil

# Server type: master|slave|ro
# Set it in the node definition
#default['postgresql']['server']['type'] = 'master'

# Enable replication 
default['postgresql']['server']['replication'] = false

# oe-postgresql::sysctl
default['postgresql']['sysctl']['cfg']   = '/etc/sysctl.d/99-postgresql.conf'
default['postgresql']['sysctl']['attrs'] = {}

# oe-postgresql
default['postgresql']['pg_hba'] = [
  { :type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident' },
  { :type => 'local', :db => 'all', :user => 'all', :addr => nil,      :method => 'ident' },
  { :type => 'host',  :db => 'repmgr', :user => 'repmgr', :addr => '0/0', :method => 'md5' },
  { :type => 'host',  :db => 'replication', :user => 'all', :addr => '0/0', :method => 'md5' },
  { :type => 'host',  :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5' },
]

default['postgresql']['prefix'] = {
  'home'        => node['postgresql']['user']['home'],
  'install'     => "/usr/lib/postgresql/#{node['postgresql']['version']}",
  'cfg'         => "/etc/postgresql/#{node['postgresql']['version']}/main",
  'data'        => "/var/lib/postgresql/#{node['postgresql']['version']}/main",
  'scripts'     => '/usr/lib/postgresql/scripts',
  'scripts_sql' => '/usr/lib/postgresql/scripts/sql',
  'archives'    => '/mnt/archives',
  'backups'     => '/mnt/archives/base_archive',
  'walfiles'    => '/mnt/archives/wal_files',
  'log'         => '/mnt/log/postgresql',
}

# FIXME: verify s3cmd exists / what buckets to use
#  'archive_command'            => 'test ! -f /mnt/archives/wal_files/%f && gzip -c %p > /mnt/archives/wal_files/%f && s3cmd -c /var/lib/postgresql/.s3cfg put /mnt/archives/wal_files/%f s3://openenglish-DB/PRD/PP/wal_archives/%f',

# oe-postgresql::default
default['postgresql']['required'] = {
  'resources' => [ 
    'shared_buffers',
    'work_mem',
    #'maintenance_work_mem',
  ],
  'wal' => [
    'archive_command',
  ]
}

default['postgresql']['config'] = {
  'locations' => {}, 'conns'       => {}, 'security'   => {}, 'resources' => {},
  'wal'       => {}, 'replication' => {}, 'queries'    => {}, 'log'       => {},
  'stats'     => {}, 'autovacuum'  => {}, 'client'     => {}, 'locking'   => {},
  'compat'    => {}, 'errors'      => {}, 'extensions' => {},
}

# Defaults divided by section
default['postgresql']['defaults']['config'] = {
  'locations' => {
    'data_directory'    => node['postgresql']['prefix']['data'],
    'hba_file'          => "#{node['postgresql']['prefix']['cfg']}/pg_hba.conf",
    'ident_file'        => "#{node['postgresql']['prefix']['cfg']}/pg_ident.conf",
    'external_pid_file' => "/var/run/postgresql/#{node['postgresql']['version']}-main.pid",
  },

  'conns' => {
    'listen_addresses'      => '*',
    'port'                  => 5432,
    'max_connections'       => 101,
    'unix_socket_directory' => '/var/run/postgresql',
  },

  'security' => {
    'ssl'           => true,
    'ssl_cert_file' => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    'ssl_key_file'  => '/etc/ssl/private/ssl-cert-snakeoil.key',
  },

  'resources' => {
    'shared_preload_libraries' => nil,
  },

  'wal' => {
    'wal_level'                 => 'hot_standby',
    'archive_mode'              => 'on',
    'archive_timeout'           => '600',
    #'shared_preload_libraries'  => 'repmgr_funcs',
  },

  'replication' => {
    'max_wal_senders'   => '4',
    'wal_keep_segments' => '50',
    'hot_standby'       => 'on',
  },

  'queries' => {
    'random_page_cost'     => '1.1',
    'cpu_tuple_cost'       => '0.0030',
    'cpu_index_tuple_cost' => '0.0010',
    'cpu_operator_cost'    => '0.0005',
  },

  'log' => {
    'log_directory'              => node['postgresql']['prefix']['log'],
    'log_filename'               => "postgresql-#{node.chef_environment.to_str}-%Y-%m-%d_%H%M%S.log",
    'log_file_mode'              => '0640',
    'log_destination'            => 'stderr',
    'logging_collector'          => 'on',
    'log_rotation_age'           => '1d',
    'log_rotation_size'          => '10',
    'client_min_messages'        => 'ERROR',
    'log_min_messages'           => 'warning',
    'log_min_error_statement'    => 'error',
    'log_min_duration_statement' => '1000',
    'debug_pretty_print'         => 'on',
    'log_checkpoints'            => 'on',
    'log_connections'            => 'on',
    'log_disconnections'         => 'on',
    'log_duration'               => 'off',
    'log_line_prefix'            => '%t [%p]: [%l-1] %m %u@%d %p %r',
    'log_lock_waits'             => 'on',
    'log_statement'              => 'mod',
    'log_temp_files'             => '256',
    'log_timezone'               => 'EST',
  },

  'client' => {
    'datestyle'                  => 'iso, mdy',
    'lc_messages'                => 'en_US.UTF-8',
    'lc_monetary'                => 'en_US.UTF-8',
    'lc_numeric'                 => 'en_US.UTF-8',
    'lc_time'                    => 'en_US.UTF-8',
    'default_text_search_config' => 'pg_catalog.english',
  },

  'locking' => {
    'deadlock_timeout' => '1s',
  }
  
}

default['postgresql']['databases'] = []

default['repmgr']['db'] = {
  'user' => 'repmgr',
  'db'   => 'repmgr',
}

# Required attributes for repmgr
default['repmgr']['required'] = [ 'cluster', 'node' ]

# Empty configuration for repmgr.
# Defaults will be generated from node['repmgr']['defaults']['config']
# 'cluster' => name # This should be defined as a Role / Environment attribute
# 'node'    => int  # This should be defined as a Node attribte
default['repmgr']['config'] = {}

default['repmgr']['defaults']['config'] = {
  'conninfo' => "'host=#{node['ipaddress']} user=#{node['repmgr']['db']['user']} dbname=#{node['repmgr']['db']['db']}'",
  'rsync_options'      => '--archive --checksum --compress --progress --rsh=ssh',
  'reconnect_attempts' => 18,
  'reconnect_interval' => 10,
  'failover'           => 'automatic',
  'priority'           => 1,
  'promote_command'    => "#{node['postgresql']['prefix']['scripts']}/promote.sh",
  'loglevel'           => 'NOTICE',
}

default['postgresql']['ssh_keys'] = nil

# oe-postgresql::logs
default['oe-logs']['services']['postgresql'] = {
  'log' => {
    'prefix'  => node['postgresql']['prefix']['log'],
    'symlink' => '/var/log/postgresql',
    'owner'   => node['postgresql']['user']['name'],
    'group'   => node['postgresql']['group']['name']
  },
  'logrotate' => {
    'logfile'      => '/var/log/postgresql/*.log',
    'interval'     => 'weekly',
    'rotate_count' => '10',
    'owner'        => 'root',
    'group'        => 'root'
  }
}

