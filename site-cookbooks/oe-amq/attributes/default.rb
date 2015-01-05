# java
default["java"]["install_flavor"] = "oracle"
default["java"]["java_home"] = "/usr/lib/jvm/java-7-oracle-amd64"
default["java"]["jdk"]["7"]["x86_64"]["checksum"] = "f80dff0e19ca8d038cf7fe3aaa89538496b80950f4d10ff5f457988ae159b2a6"
default["java"]["jdk"]["7"]["x86_64"]["url"] = "https://infra-packages.s3.amazonaws.com/jdk-7u25-linux-x64.tar.gz"
default["java"]["jdk_version"] = "7"
default["java"]["oracle"]["accept_oracle_download_terms"] = true

# oe-amq::amq 
default['amq']['jars_url'] = 'https://s3.amazonaws.com/infra-packages/lp2/amq'
default['amq']['version'] = '5.6.0'
default['amq']['url'] = 'https://infra-packages.s3.amazonaws.com/apache-activemq/5.6.0/apache-activemq-5.6.0-bin.tar.gz'
default['amq']['checksum'] = '801a479c02f38910894d32ab62ec30c2a266bf310f2ed745570636a44e04f58b'



#default['jdk']['7']['x86_64']['url'] = 'https://infra-packages.s3.amazonaws.com/jdk-7u25-linux-x64.tar.gz'
#default['jdk']['7']['x86_64']['checksum'] = 'f80dff0e19ca8d038cf7fe3aaa89538496b80950f4d10ff5f457988ae159b2a6'

# oe-amq::amq => Enabled Web Login Console
default['amq']['jmxuser'] = 'admin'
default['amq']['jmxpass'] = 'admin'

# oe-amq::amq => Enabled other configuration parameters
default['amq']['jmxport'] = '39193'
default['amq']['activemq_opts_memory'] = '-Xmx1280M -Xms1280M'
default['amq']['memoryusage'] = '64 mb'
default['amq']['storeusage'] = '20 gb' 
default['amq']['tempusage'] = '20 gb' 

# oe-amq::amq => Enabled jdbc settings
default['amq']['jdbc_enabled'] = false 
default['amq']['jdbc_user'] = '' 
default['amq']['jdbc_host'] = ''
default['amq']['jdbc_db'] = ''
default['amq']['jdbc_port'] = ''
default['amq']['jdbc_datasource'] = ''
default['amq']['jdbc_initial_connections'] = ''
default['amq']['jdbc_max_connections'] = ''
default['amq']['jdbc_pass'] = ''

# oe-logs::logs
default['oe-logs']['services']['activemq'] = {
  'log' => {
    'prefix'  => '/mnt/log/activemq',
    'symlink' => '/opt/activemq/data',
    'owner'   => 'activemq',
    'group'   => 'staff'
  },
# oe-logs::logrotate
  'logrotate' => {
    'logfile'      => '/mnt/log/activemq/activemq.log',
    'interval'     => 'daily',
    'rotate_count' => '90',
    'owner'        => 'activemq',
    'group'        => 'root'
  }
}

# oe-monitoring::appdynamic
default['monitoring']['appdynamics']['enabled'] = true 
default['amq']['java_options'] = '' 


