require 'chefspec'
require 'fauxhai'
require 'json'

@platforms = {
  'Ubuntu 12.04' => {
    :cookbook_path => [ '../../site-cookbooks', '../../cookbooks' ],
    :platform      => 'ubuntu',
    :version       => '12.04',
    :environment   => 'some-stg',
    
    'etc' => {
      'passwd' => {
        'user1' => {
          'dir' => '/home/user1'
        }
      },
      'group' => {
        'group1' => {
          'members' => [ 'user1' ]
        }
      }
    },

    :postgresql => {
      
      'version' => '9.2',
      'mailto'  => 'dba@openenglish.com',
      
      'data_bag' => {
        'users' => 'db'
      },
      'data_bag_item' => {
        'users' => 'users'
      },

      'server'  => {
        'packages' => %w{ postgresql postgresql-doc }
      },
      'client'  => {
        'packages' => %w{ postgresql-client }
      },

      'prefix' => {
        'install'  => '/usr/lib/postgresql/9.2',
        'cfg'      => '/etc/postgresql/9.2/main',
        'data'     => '/var/lib/postgresql/9.2/main',
        'backups'  => '/mnt/archives/base_archive',
        'archives' => '/mnt/archives/wal_files',
        'log'      => '/mnt/log/postgresql',
      },

      'pg_hba' => [
        { :type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident' },
        { :type => 'local', :db => 'all', :user => 'all',      :addr => nil, :method => 'ident' },
        { :type => 'host', :db => 'all',  :user => 'all',      :addr => nil, :method => 'md5' },
      ],

      # Definition of required fields
      'config' => {
        'password'                 => 'asdqwe',
        'shared_buffers'           => '1234',
        'work_mem'                 => '2345',
        'maintenance_work_mem'     => '3456',
        'shared_preload_libraries' => 'libasd',
        'archive_command'          => 'some command'
      },

      'sysctl' =>  {
        'cfg' => '/etc/sysctl.d/99-postgresql.conf',
        'attrs'  => {
          'key1' => 'value1',
          'key2' => 'value2',
        },
      },

      'databases' => [
        {
          'name'  => 'lp20',
          'owner' => 'user2',
        },
      ],

      :ssh_keys => {
        'data_bag' => 'ssh_keys',
        'user'     => 'postgres'
      },

    },

    :repmgr => {
      'prefix' => '/some/place',
      'config' => {
        'cluster' => 'some_clustername',
        'node'    => 1
      }
    },

    # Spec: postgresql_log
    'oe-logs' => {
      'logrotate' => {
        'prefix' => '/etc/logrotate.d'
      },

      'services' => {
        'postgresql' => {
            
          'log' => {
            'prefix'  => '/mnt/log/postgresql',
            'symlink' => '/var/log/postgresql',
            'owner'   => 'postgres',
            'group'   => 'root'
          },
          'logrotate' => {
            'logfile'      => '/var/log/postgresql/*.log',
            'interval'     => 'weekly',
            'rotate_count' => '10',
            'owner'        => 'tomcat7',
            'group'        => 'root'
          }
        }
      }
    },

    # spec: 
    :data_bags => {
      :ssh_keys => {
        'user1' => {
          'id'   => 'user1',
          'private_key' => 'PRIVATE_KEY',
          'authorized_keys'   => [
            'AUTHKEY1',
            'AUTHKEY2',
          ]

        },

      },
      :db => {
        :users => {
          'id' => 'users',
          'stg' => {
            'repmgr' => { 'password' => 'user1_password', 'superuser' => true },
            'user2'  => { 'password' => 'user2_password' },
          },
        },
      },
    },

  },
  
}

def stub_search(result)
  Chef::Recipe.any_instance.stub(:search).and_return(result)
end

def runner(attributes = {}, environment = '_default')

  chef_runner = ChefSpec::Runner.new({
    cookbook_path: attributes[:cookbook_path],
    platform:      attributes[:platform],
    version:       attributes[:version],
  }) do |node| 
    
    # Define node variables
    node.set['postgresql'] = attributes[:postgresql]
    node.set['repmgr']     = attributes[:repmgr]
    node.set['etc']        = attributes[:etc]

    env = Chef::Environment.new
    env.name environment
    
    # Stub the node to return this environment
    node.stub(:chef_environment).and_return(env.name)
    
    # Stub any calls to Environment.load to return this environment
    Chef::Environment.stub(:load).and_return(env)
    
  end #.converge(described_recipe)
  
end

