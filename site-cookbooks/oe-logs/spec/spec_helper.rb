require 'chefspec'
require 'fauxhai'
require 'json'

@platforms = {
  'Ubuntu 12.04' => {
    :cookbook_path => [ '../../site-cookbooks', '../../cookbooks' ],
    :platform      => 'ubuntu',
    :version       => '12.04',
    :environment   => 'pp2-stg',
    
    'oe-logs'  => {
      'logrotate' => {
        'prefix'   => '/etc/logrotate.d',
      },
      'services' => {
        'tomcat7' => { 
          'logrotate' => {'key' => 'value' },
          'log'       => {
            'prefix'  => '/mnt/log/tomcat7',
            'symlink' => '/var/log/tomcat7',
            'owner'   => 'tomcat7',
            'group'   => 'group',
          }
        },
        'apache2' => {
          'logrotate' => {'key' => 'value' },
          'log'       => {
            'prefix'  => '/mnt/log/apache2',
            'symlink' => '/var/log/apache2',
            'owner'   => 'www-data',
            'group'   => 'group',
          },
        },
      },
    },

    :data_bags => {
      :tomcat_properties => {
        'account_service' => {
          'id'   => 'account_service',
          'stg'  => {
          }

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
    node.set['oe-logs'] = attributes['oe-logs']

    env = Chef::Environment.new
    env.name environment
    
    # Stub the node to return this environment
    node.stub(:chef_environment).and_return(env.name)
    
    # Stub any calls to Environment.load to return this environment
    Chef::Environment.stub(:load).and_return(env)
    
  end #.converge(described_recipe)
  
end

