require 'chefspec'
require 'fauxhai'
require 'json'

@platforms = {
  'Ubuntu 12.04' => {
    :cookbook_path => [ '../../site-cookbooks', '../../cookbooks' ],
    :platform      => 'ubuntu',
    :version       => '12.04',
    :environment   => 'env-stg',
    
    :tomcat => {
    
    },

    :apache => {
      #'listen_ports'     => [ '80', '443' ],
      'dir' => '/etc/apache2',
      'vhosts' => [ '00-lp2-lcs', '00-lp2-lcs-ssl' ],
      'location_aliases' => [
        { 'location' => '/css',    'path' => '/opt/open_english/webapps/ROOT/css' },
        { 'location' => '/js',     'path' => '/opt/open_english/webapps/ROOT/js' },
        { 'location' => '/images', 'path' => '/opt/open_english/webapps/ROOT/images' },
        { 'location' => '/fonts',  'path' => '/opt/open_english/webapps/ROOT/fonts' }
      ]
    },

    :ssl => {
      'type'        => 'keystore',
      'fqdn'        => 'thinkglish.com',
      'databag'     => 'ssl',
      'databag_enc' => 'ssl-keys',
    },

    'oe-logs' => {
      'logrotate' => {
        'prefix' => '/etc/logrotate.d'
      },

      'services' => {
        'tomcat' => {
            
          'log' => {
            'prefix'  => '/mnt/log/tomcat7',
            'symlink' => '/var/log/tomcat7',
            'owner'   => 'tomcat',
            'group'   => 'lp2'
          },
          'logrotate' => {
            'logfile'      => '/var/log/tomcat7/*.log',
            'interval'     => 'daily',
            'rotate_count' => '10',
            'owner'        => 'tomcat7',
            'group'        => 'lp2'
          }
        }
      }
    },

    :databags => {
      'ssl' => { 
        'thinkglish_com'   => { 
          'id'        => 'thinkglish_com',
          'cert'      => 'ABCDE some content',
          'ca'        => 'ABCDE_ca some content',
          'chaincert' => 'ABCDE_ca some content',
        },
      },
      'ssl-keys' => { 
        'thinkglish_com' => { 
          'id'           => 'thinkglish_com',
          'key'          => 'ABCDE_key',
          'keystorePass' => 'doopersecret',
         },
      },
      'tomcat_users' => {
        'rspec' => {
          'id'       => 'rspec',
          'password' => 'some_pass',
          'roles'    => [ 'role1', 'role2' ]
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
    node.set['tomcat']  = attributes[:tomcat]
    node.set['apache']  = attributes[:apache]
    node.set['oe-logs'] = attributes['oe-logs']
    node.set['lp2-lcs']  = attributes['lp2-lcs']

    env = Chef::Environment.new
    env.name environment
    
    # Stub the node to return this environment
    node.stub(:chef_environment).and_return(env.name)
    
    # Stub any calls to Environment.load to return this environment
    Chef::Environment.stub(:load).and_return(env)
    
  end #.converge(described_recipe)
  
end

