require 'chefspec'
require 'fauxhai'
require 'json'

@platforms = {
  'Ubuntu 12.04' => {
    :cookbook_path => [ '../../site-cookbooks', '../../cookbooks' ],
    :platform      => 'ubuntu',
    :version       => '12.04',
    :environment   => 'pp2-stg',
    
    :ssh_keys => {
      'data_bag' => 'ssh_keys'
    },

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

    :data_bags => {
      :ssh_keys => {
        'user1' => {
          'id'   => 'user1',
          'private_key' => 'PRIVATE_KEY',
          'auth_keys'   => [
            'AUTHKEY1',
            'AUTHKEY2',
          ]

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
    node.set['ssh_keys'] = attributes[:ssh_keys]
    node.set['etc']      = attributes['etc']

    env = Chef::Environment.new
    env.name environment
    
    # Stub the node to return this environment
    node.stub(:chef_environment).and_return(env.name)
    
    # Stub any calls to Environment.load to return this environment
    Chef::Environment.stub(:load).and_return(env)
    
  end #.converge(described_recipe)
  
end

