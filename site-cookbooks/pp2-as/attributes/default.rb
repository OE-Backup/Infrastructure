# pp2-as::fo
default['fo']['dir'] = '/opt/fo'


# oe-tomcat::default
default['ssl']['fqdn'] = 'thinkglish.com'
default['pp2']['domain'] = 'thinkglish_com'
#pp2_ssl = Chef::DataBagItem.load("ssl", default['pp2']['domain'])
#pp2_ssl_key = Chef::EncryptedDataBagItem.load("ssl-keys", default['pp2']['domain'])

default["tomcat"]["jars"] = {
  :add => [
    { 
      :name   => "postgresql-9.2-1002-jdbc4.jar", 
      :digest => "cd1824fa8c059e6376c92020f1e7fe6c6f34772e9f91711327e414f1b979fbe1",
      :dst    => "/usr/share/tomcat7/lib"
    },
    {
      :name   => "catalina-jmx-remote.jar",
      :digest => "4973c02140b67e31550ddfc5fbdbd5c577888ee29153c8df0fa8430f46aade95",
      :dst    => "/usr/share/tomcat7/lib"
    }
  ]
}

default["java"]["jars"] = {
  :add => [
    { 
      :name   => "local_policy.jar",
      :digest => "4a5c8f64107c349c662ea688563e5cd07d675255289ab25246a3a46fc4f85767" ,
      :dst    => "/usr/lib/jvm/java-7-oracle-amd64/jre/lib/security"
    },
    { 
      :name   => "US_export_policy.jar",
      :digest => "b800fef6edc0f74560608cecf3775f7a91eb08d6c3417aed81a87c6371726115" ,
      :dst    => "/usr/lib/jvm/java-7-oracle-amd64/jre/lib/security"
    }
  ]
}


#default["tomcat"]["propfiles"] = [
#  { :src => "as.properties", :databagi => "account_service" },
#]

default["tomcat"]["java_options"] = "-Djava.awt.headless=true -XX:+UseConcMarkSweepGC -XX:+HeapDumpOnOutOfMemoryError -server -d64 -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=256m -Duser.language=en -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.local.only=true -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -XX:+UnlockDiagnosticVMOptions -XX:+LogVMOutput -XX:LogFile=/var/log/tomcat7/jvm.log"

default["tomcat"]["authbind"] = "yes"
default["tomcat"]["deploy_manager_apps"] = "true"
default["tomcat"]["propfiles_prefix"] = "/opt/pp2/env"
default["tomcat"]["port"] = "8080"
default["tomcat"]["ssl_port"] = "8443"

default["ssl"]["fqdn"]  = "thinkglish.com"
default["ssl"]["type"]  = "keystore"
default["ssl"]["owner"] = "tomcat7"
default["ssl"]["group"] = "root"

# oe-tomcat::cacerts
default['tomcat']['ssl']['certs_dir']     = '/opt/pp2/ssl/cacerts'

#oe-ssl
default['ssl']['pem'] = {
  'prefix' => '/opt/pp2/ssl',
}

default['ssl']['keystore'] = {
  'prefix' => '/opt/pp2/ssl',
}

default['ssl']['pkcs12'] = {
  'prefix' => '/opt/pp2/ssl',
}

# oe-logs::logs
#default['oe-logs']['services']['as_app'] = {
#  'log' => {
#    'prefix'  => '/mnt/log/as',
#    'symlink' => '/var/log/as',
#    'owner'   => 'tomcat7',
#    'group'   => 'tomcat7'
#  },
# oe-logs::logrotate
#  'logrotate' => {
#    'logfile'      => '/mnt/log/ps/account_service.log',
#    'interval'     => 'daily',
#    'rotate_count' => '90',
#    'owner'        => 'tomcat7',
#    'group'        => 'tomcat7'
#  }
#}

