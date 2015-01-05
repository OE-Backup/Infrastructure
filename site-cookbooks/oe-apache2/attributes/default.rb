# oe-tomcat::apache
store2_ssl = Chef::DataBagItem.load("ssl", 'thinkglish_com')
store2_ssl_key = Chef::EncryptedDataBagItem.load("ssl-keys", 'thinkglish_com')
default['ssl']['fqdn'] = 'thinkglish.com'
default['apache']['ssl']['chaincert'] = store2_ssl["chaincert"]
default['apache']['ssl']['cert'] = store2_ssl["cert"]
default['apache']['ssl']['key'] = store2_ssl_key["key"]

# oe-logs::logs
default['oe-logs']['services']['apache2'] = {
  'log' => {
    'prefix'  => '/mnt/log/apache2',
    'symlink' => '/var/log/apache2',
    'owner'   => 'root',
    'group'   => 'adm'
  },

# oe-logs::logrotate
  'logrotate' => {
    'logfile'      => '/var/log/apache2/access.log',
    'interval'     => 'daily',
    'rotate_count' => '90',
    'owner'        => 'root',
    'group'        => 'adm'
  },

  'logrotate' => {
    'logfile'      => '/var/log/apache2/access-ssl.log',
    'interval'     => 'daily',
    'rotate_count' => '90',
    'owner'        => 'root',
    'group'        => 'adm'
  },
  'logrotate' => {
    'logfile'      => '/var/log/apache2/error.log',
    'interval'     => 'daily',
    'rotate_count' => '90',
    'owner'        => 'root',
    'group'        => 'adm'
  },
  'logrotate' => {
    'logfile'      => '/var/log/apache2/error-ssl.log',
    'interval'     => 'daily',
    'rotate_count' => '90',
    'owner'        => 'root',
    'group'        => 'adm'
  }
} 
