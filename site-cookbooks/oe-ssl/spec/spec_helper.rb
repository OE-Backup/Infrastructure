require 'chefspec'
require 'fauxhai'
require 'json'

@platforms = {
  'Ubuntu 12.04' => {
    :cookbook_path => [ '../../site-cookbooks', '../../cookbooks' ],
    :platform      => 'ubuntu',
    :version       => '12.04',
    :environment   => 'pp2-prd',

    
    :ssl => {
      'databag'     => 'ssl',
      'databag_enc' => 'ssl-keys',
      'fqdn'        => 'foo.bar',
      'owner'       => 'root',
      'group'       => 'root',
      'service'     => 'tomcat',

      'pem' => {
        'prefix' => '/etc/apache2/sites-conf',
      },

      'keystore' => {
        'prefix' => '/etc/apache2/sites-conf',
        'pass'   => 'changeit',
      },

      'pkcs12' => {
        'prefix' => '/etc/ssl',
      },

    },

    :databags => {
      'ssl' => { 
        'foo_bar'   => { 
          'id'        => 'foo_bar',
          'cert'      => 'ABCDE some content',
          'ca'        => 'ABCDE_ca some content',
          'chaincert' => 'ABCDE_chain some content',
        },
      },
      'ssl-keys' => { 
        'foo_bar' => { 
          'id'           => 'foo_bar',
          'key'          => 'ABCDE_key',
          'keystorePass' => 'doopersecret',
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
    node.set['ssl'] = attributes[:ssl]

    env = Chef::Environment.new
    env.name environment
    
    # Stub the node to return this environment
    node.stub(:chef_environment).and_return(env.name)
    
    # Stub any calls to Environment.load to return this environment
    Chef::Environment.stub(:load).and_return(env)
    
  end #.converge(described_recipe)
  
end

