require 'chefspec'
require 'json'

@platforms = {
  'Ubuntu 12.04' => {
    :cookbook_path => [ '../../site-cookbooks', '../../cookbooks' ],
    :platform      => 'ubuntu',
    :version       => '12.04',
    :environment   => 'test-stg',
    
    :tomcat => {
      
      'version' => 7,
      'user'  => 'tomcat7',
      'group' => 'tomcat7',
      'dirs' => { 
        'home'     => "/usr/share/tomcat7",
        'base'     => "/var/lib/tomcat7",
        'config'   => "/etc/tomcat7",
        'context'  => "/etc/tomcat7/Catalina/localhost",
        'webapp'   => "/var/lib/tomcat7/webapps",
        'work'     => "/var/cache/tomcat7",
        'tmp'      => "/tmp/tomcat7-tmp",
        'lib'      => "/usr/share/tomcat7/lib",
        'endorsed' => "/usr/share/tomcat7/lib/endorsed",
        'log'      => "/var/log/tomcat7",
      },
      
      'libs_url' => 'http://myrepo.foo.bar/somewhere',
      'lib_dir'  => '/foo/bar/lib',
      'jars'     => {
        :add  => [ 
          { :name => 'kryo-1.04.jar',                 :digest => '123456' },
          { :name => 'msm-kryo-serializer-1.6.5.jar', :digest => 'qwerty' },
          { :name => 'couchbase-client-1.1.4.jar',    :digest => 'asdfgh' },
        ],

        :remove => [
          'memcached-session-manager-tc7-1.6.5.jar',
          'catalina-jmx-remote.jar',
          'spymemcached-2.10.3.jar',
        ],
      },
 
      # Spec: propfiles
      'default'          => '/etc/default/tomcat7',
      'propfiles_prefix' => '/opt/env',
      'propfiles'        => [ 
        { 'src' => 'file1.properties', 'dst'=> 'env' },
      ],
 
      "ssl" => { 
        'certs_dir'   => '/opt/dir',
      },

      "log4j" => {
        'filename'  => '/opt/log4j.xml',
        'group'     => 'group1',
        'mode'      => '0644',
        'appenders' => [
          {
            'name'  => 'someAppender',
            'file'  => '/var/some/log',
          }
        ]
      },

      "context" => {
        "databag"      => "some_databag",
        "databag_item" => "item_1",
      }
    },

    :ssl => {
      'databag'     => 'ssl',
      'databag_enc' => 'ssl_key',
      'fqdn'        => 'foo.bar',
      'owner'       => 'root',
      'group'       => 'root',
      'service'     => 'tomcat',
      
      'pem' => {
        'prefix' => '/etc/apache2/sites-conf',
      },
      
      'keystore' => {
        'prefix' => '/etc/apache2/sites-conf',
      },
      
      'pkcs12' => {
        'prefix' => '/etc/ssl',
      },
    
    },
 
    # spec: tomcat_tomcat_spec
    :tomcat_users => {
      'admin' => {
        'id'       => 'admin',
        'password' => '12345',
        'roles'    => [ 'script-manager' ]
      },
    },

    # spec: tomcat_propfiles_spec / tomcat_ssl_spec
    :databags => {
      :tomcat_properties => {
        'account_service' => {
          'id'   => 'account_service',
          'stg'  => {
            'VAR1' => 'asd',
            'VAR2' => 'dfg',
            'VAR3' => 'qwe',
          }
        },
      },

      'db' => {
        'db_users' => {
          'stg' => {
            'id'     => 'test',
            'user_1' => {
              'password' => 'password_1'
            }
          }
        }
      },
      
      'ssl' => { 
        'foo_bar'   => { 
          'id'    => 'foo_bar',
          'cert'  => 'ABCDE some content',
          'ca'    => 'ABCDE_ca some content',
          'chain' => 'ABCDE_ca some content',
        },
        'cacerts' => {
          'cert_a' => 'content_cert_a',
          'cert_b' => 'content_cert_b',
        },
      },
      'ssl_key' => { 
        'foo_bar' => { 
          'id'          => 'foo_bar',
          'key'         => 'ABCDE_key',
          'keystorePass' => 'doopersecret',
         },
      },

      'some_databag' => {
        'item_1' => {
          'id' => 'item_1',
          'context' => 'some_ctx',
          'jdbc' => {
            'username'  => 'user_1',
            'jdbc_key1' => 'jdbc_value1'
          },
          'memcache' => {
            'memcache_key1' => 'memcache_value1'
          }
        }
      }
    
    },

  },
  
}

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

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
    node.set['tomcat'] = attributes[:tomcat]
    node.set['ssl']    = attributes[:ssl]

    env = Chef::Environment.new
    env.name environment
    
    # Stub the node to return this environment
    node.stub(:chef_environment).and_return(env.name)
    
    # Stub any calls to Environment.load to return this environment
    Chef::Environment.stub(:load).and_return(env)
    
  end #.converge(described_recipe)
  
end

