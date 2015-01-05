require 'chefspec'
require 'fauxhai'
require 'json'

def stub_search(result)
  Chef::Recipe.any_instance.stub(:search).and_return(result)
end

@platforms = {
  'Ubuntu 12.04' => {
    :cookbook_path  => [ '../../site-cookbooks', '../../cookbooks' ],
    :platform       => 'ubuntu',
    :version        => '12.04',
    
    :ssl => {
      :fqdn => 'foo.bar',
      :pem => {
        'prefix' => '/etc/apache2/sites-conf',
      },
    },

    :data_bags => {
      'ssl' => { 
        'foo_bar'   => { 
          'id'    => 'foo_bar',
          'cert'  => { 'filename' => 'foo.bar.crt',   'content' => 'ABCDE some content' },
          'ca'    => { 'filename' => 'foo.bar.ca',    'content' => 'ABCDE_ca some content' },
          'chain' => { 'filename' => 'foo.bar.chain', 'content' => 'ABCDE_ca some content' },
        },
      },
      'ssl_key' => { 
        'foo_bar'   => { 
          'id'  => 'foo_bar',
          'key' => { 'filename' => 'foo.bar.key',  'content' => 'ABCDE_key' },
         },
      },
    },
  
  },
  
}

