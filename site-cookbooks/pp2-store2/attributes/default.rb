# oe-tomcat::apache
default['ssl']['fqdn'] = 'thinkglish.com'
default['store2']['domain'] = 'thinkglish_com'
store2_ssl = Chef::DataBagItem.load("ssl", default['store2']['domain'])
store2_ssl_key = Chef::EncryptedDataBagItem.load("ssl-keys", default['store2']['domain'])

default['apache']['ssl']['chaincert'] = store2_ssl["chaincert"]
default['apache']['ssl']['cert'] = store2_ssl["cert"]
default['apache']['ssl']['key'] = store2_ssl_key["key"]

# mod_proxy settings
default['apache']['proxy']['deny_from']  = 'none'
default['apache']['proxy']['allow_from'] = 'all'

# oe-tomcat::default
#default['java']['install_flavor'] = 'oracle'
#default['java']['java_home'] = '/usr/lib/jvm/java-6-oracle-amd64'
#default['java']['jdk']['6']['x86_64']['url'] = 'https://s3.amazonaws.com/infra-packages/jdk/jdk-6u45-linux-x64.bin'
#default['java']['jdk']['6']['x86_64']['checksum'] = '6b493aeab16c940cae9e3d07ad2a5c5684fb49cf06c5d44c400c7993db0d12e8'
#default['java']['jdk_version'] = '6'
#default['java']['oracle']['accept_oracle_download_terms'] = true

default['tomcat']['java_options'] = '-server -Xms1024m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=256m -Djava.awt.headless=true -XX:+UseConcMarkSweepGC  -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:/var/log/tomcat7/gc.log -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false'

default['tomcat']['authbind'] = 'yes'
default['tomcat']['deploy_manager_apps'] = 'true'
default['tomcat']['port']     = '8080'

# oe-tomcat::libs
default['tomcat']['jars'] = {
  :add => [
     { 
       :name   => 'asm-3.2.jar',
       :digest => '1ac3b6e18dbd7053cdbef7374b8401ad7ff64ceb80060ccace4dc35e6eb89d49' 
     },
     { 
       :name   => 'kryo-1.04.jar',
       :digest => '66db375e68c91d3938c91ede5bf3af370cdbcccbe81c9bf325c20845de855cd8'
     },
     {
       :name   => 'kryo-serializers-0.11.jar',
       :digest => '22252e3a6904917357adfaa5ed4394992c1e4e22f8dbdcf639ff9d29681d7ce7'
     },
     {
       :name   => 'memcached-session-manager-1.8.1.jar',
       :digest => 'f25810d52932e5cba14958b65a90a22cf874f610ddfa6ffcf1167fe4d71a150b'
     },
     {
       :name   => 'memcached-session-manager-tc7-1.8.1.jar',
       :digest => 'b8b540b0fad843622e22f85e8a51f4da1bd819775f51e84ca432975c9434000b' 
     },
     {
       :name   => 'minlog-1.2.jar',
       :digest => '4ac7ce56b1ec76852d072cea636758d71b91e8d58a0393b6ba43ea54740ef480' 
     },
     {
       :name   => 'msm-kryo-serializer-1.8.1.jar',
       :digest => '989a661c611ffb5d1261612a6e7394a8c7e695b929fe324a3069ebc6cb9803ab' 
     },
     {
       :name   => 'reflectasm-1.01.jar',
       :digest => '471aec8479fc610c996acc685a85e00e98f1d89e5ca14dc226327feb8daaa6ba' 
     },
     {
       :name   => 'spymemcached-2.10.2.jar',
       :digest => '57b8cb5a15ffa24b6a8ec1dc763f283fd2ce2be7552a9568ea7b9af50e2e1044' 
     },
     {
      :name   => "catalina-jmx-remote.jar",
      :digest => "4973c02140b67e31550ddfc5fbdbd5c577888ee29153c8df0fa8430f46aade95"
     },
  ],

  :remove => [],
}

# oe-tomcat::propfiles
default['tomcat']['propfiles_prefix'] = '/opt/store2/env'

# oe-ssl
default['ssl']['type']    = 'keystore'
default['ssl']['owner']   = 'tomcat7'
default['ssl']['group']   = 'root'
default['ssl']['service'] = 'tomcat'


#oe-tomcat::cacerts
default['tomcat']['ssl']['certs_dir']     = '/opt/store2/ssl/cacerts'

#oe-ssl
default['ssl']['pem'] = {
  'prefix' => '/opt/store2/ssl',
}

default['ssl']['keystore'] = {
  'prefix' => '/opt/store2/ssl',
}

default['ssl']['pkcs12'] = {
  'prefix' => '/opt/store2/ssl',
}
