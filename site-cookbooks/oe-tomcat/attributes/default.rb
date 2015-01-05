 
default['tomcat']['version'] = 7
default['tomcat']['user']    = "tomcat#{node['tomcat']['version']}"
default['tomcat']['group']   = "tomcat#{node['tomcat']['version']}"

default['tomcat']['packages'] = [
  "tomcat#{node['tomcat']['version']}",
  "tomcat#{node['tomcat']['version']}-admin",
]

default['tomcat']['users']['databag']  = 'tomcat_users'
default['tomcat']['databag_encrypted'] = true

default['tomcat']['dirs'] = {
  'home'     => "/usr/share/tomcat#{node['tomcat']['version']}",
  'base'     => "/var/lib/tomcat#{node['tomcat']['version']}",
  'config'   => "/etc/tomcat#{node['tomcat']['version']}",
  'context'  => "/etc/tomcat#{node['tomcat']['version']}/Catalina/localhost",
  'webapp'   => "/var/lib/tomcat#{node['tomcat']['version']}/webapps",
  'work'     => "/var/cache/tomcat#{node['tomcat']['version']}",
  'tmp'      => "/tmp/tomcat#{node['tomcat']['version']}-tmp",
  'lib'      => "/usr/share/tomcat#{node['tomcat']['version']}/lib",
  'endorsed' => "/usr/share/tomcat#{node['tomcat']['version']}/lib/endorsed",
  'log'      => "/var/log/tomcat#{node['tomcat']['version']}",
}

# TODO: to be removed
default["tomcat"]["home"] = "/usr/share/tomcat#{node["tomcat"]["version"]}"
default["tomcat"]["base"] = "/var/lib/tomcat#{node["tomcat"]["version"]}"
default["tomcat"]["config_dir"]   = node['tomcat']['dirs']['config']
default["tomcat"]["log_dir"]      = node['tomcat']['dirs']['log']
default["tomcat"]["tmp_dir"]      = node['tomcat']['dirs']['tmp']
default["tomcat"]["work_dir"]     = node['tomcat']['dirs']['work']
default["tomcat"]["context_dir"]  = node['tomcat']['dirs']['context']
default["tomcat"]["webapp_dir"]   = node['tomcat']['dirs']['webapp']
default["tomcat"]["lib_dir"]      = node['tomcat']['dirs']['lib']
default["tomcat"]["endorsed_dir"] = node['tomcat']['dirs']['endorsed']
default["tomcat"]["keytool"]      = '/usr/lib/jvm/java/bin/keytool'

# Probably better at tomct.config.abc
default['tomcat']['port'] = 8080
default['tomcat']['proxy_port'] = nil
default['tomcat']['ssl_port'] = 8443
default['tomcat']['ssl_proxy_port'] = nil
default['tomcat']['ajp_port'] = 8009
default['tomcat']['catalina_options'] = ""
default['tomcat']['java_options'] = "-Xmx128M -Djava.awt.headless=true"
default['tomcat']['use_security_manager'] = false
default['tomcat']['authbind'] = "no"
default['tomcat']['deploy_manager_apps'] = true
default['tomcat']['ssl_cert_file'] = nil
default['tomcat']['ssl_key_file'] = nil
default['tomcat']['ssl_chain_files'] = [ ]
default['tomcat']['keystore_file'] = "keystore.jks"
default['tomcat']['keystore_type'] = "jks"

default["tomcat"]["truststore_type"] = "jks"
default["tomcat"]["loglevel"] = "INFO"
default["tomcat"]["tomcat_auth"] = "true"

# oe-tomcat::default
default['ssl']['fqdn'] = 'thinkglish.com'
default['ssl']['type'] = 'keystore' 
default['ssl']['service'] = 'tomcat'

default['tomcat']['context'] = {}

# oe-tomcat::probe
default['tomcat']['probe_war'] = 'https://s3.amazonaws.com/infra-packages/probe/oe-probe-tomcat7.war'
default['tomcat']['probe_checksum'] = '103ab8b1ea54ee5e5ddb3b066d3987dcca87469e83308b95a6a16a55d6e3a91d'  

# oe-tomcat::tomcat
default['tomcat']['jmx'] = "true"
default['jmx']['rmiRegistryPortPlatform'] = 39193
default['jmx']['rmiServerPortPlatform'] = 39194
default["java"]["install_flavor"] = "oracle"
default["java"]["java_home"] = "/usr/lib/jvm/java-7-oracle-amd64"
default["java"]["jdk"]["7"]["x86_64"]["checksum"] = "f80dff0e19ca8d038cf7fe3aaa89538496b80950f4d10ff5f457988ae159b2a6"
default["java"]["jdk"]["7"]["x86_64"]["url"] = "https://infra-packages.s3.amazonaws.com/jdk-7u25-linux-x64.tar.gz"
default["java"]["jdk_version"] = "7"
default["java"]["oracle"]["accept_oracle_download_terms"] = true
default["tomcat"]["version"] = 7
default["tomcat"]["deploy_manager_apps"] = true

default["tomcat"]["java_options"] = "-Dssm.cache.disable=true -Djava.awt.headless=true -XX:+UseConcMarkSweepGC -XX:+HeapDumpOnOutOfMemoryError -server -d64 -Xms384m -Xmx384m -XX:PermSize=96m -XX:MaxPermSize=96m -Duser.language=en -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=true -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -XX:+UnlockDiagnosticVMOptions -XX:+LogVMOutput -XX:LogFile=/var/log/tomcat7/jvm.log -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

default["tomcat"]["keytool"] = "/usr/bin/keytool"
default["prd"]["certicate"] = "oesys"

# oe-tomcat::libs
default['tomcat']['libs_url'] = 'https://s3.amazonaws.com/infra-packages/tomcat-libs'
default['tomcat']['jars']     = { 
  :add => 
    [
      {
        :name   => "catalina-jmx-remote.jar",
        :digest => "4973c02140b67e31550ddfc5fbdbd5c577888ee29153c8df0fa8430f46aade95",
        :dst    => "/usr/share/tomcat7/lib"
      }
    ], 
  :remove => [] 
}

default['java']['libs_url'] = 'https://s3.amazonaws.com/infra-packages/java-libs'
default['java']['jars']     = { :add => [], :remove => [] }

# oe-tomcat::propfiles
default['tomcat']['propfiles_prefix'] = '/opt/env'

# oe-tomcat::cacerts
default['tomcat']['ssl']['certs_dir']     = '/etc/open-english/ssl/cacerts'
default['tomcat']['ssl']['databag']       = 'ssl'
default['tomcat']['ssl']['databag_item']  = 'cacerts'
default['tomcat']['ssl']['keystore']      = "#{node['java']['java_home']}/jre/lib/security/cacerts"
default['tomcat']['ssl']['keystore_pass'] = "changeit"

# oe-tomcat::logs
default['oe-logs']['services']['tomcat'] = {
  'log' => {
    'prefix'  => '/mnt/log/tomcat7',
    'symlink' => '/var/log/tomcat7',
    'owner'   => 'tomcat7',
    'group'   => 'root'
  },
  'logrotate' => {
    'logfile'      => '/mnt/log/tomcat7/catalina.out',
    'interval'     => 'daily',
    'rotate_count' => '90',
    'owner'        => 'tomcat7',
    'group'        => 'root'
  }
}

