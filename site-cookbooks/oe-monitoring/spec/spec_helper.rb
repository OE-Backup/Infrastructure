
require 'chefspec'
require 'fauxhai'
require 'chef'

@platforms = {
  'Ubuntu 12.04' => {
    :cookbook_path => [ '../../site-cookbooks', '../../cookbooks' ],
    :platform      => 'ubuntu',
    :version       => '12.04',
    :environment   => 'pp2-stg',
    
    'monitoring'  => {
      'loggly' => {
        'prefix'  => '/etc/rsyslog.d',

        'enabled' => true,
        'services' => {
          'tomcat' => {
            'filename' => '/var/log/some/file.log',
            'tags'     => [ 'a', 'b' ],
          }
        }
      },
    },

    :data_bags => {
      'third-party' => {
        'loggly' => {
          'id'   => 'loggly',
          'stg'  => {
            'id' => 'some_id'
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
    node.set['monitoring'] = attributes['monitoring']

    env = Chef::Environment.new
    env.name environment
    
    # Stub the node to return this environment
    node.stub(:chef_environment).and_return(env.name)
    
    # Stub any calls to Environment.load to return this environment
    Chef::Environment.stub(:load).and_return(env)
    
  end #.converge(described_recipe)
  
end

