# oe-tomcat::apache
default['ssl']['fqdn'] = 'oe-sys.com'
default['salesforce']['domain'] = 'oe-sys_com'
salesforce_ssl = Chef::DataBagItem.load("ssl", default['salesforce']['domain'])
salesforce_ssl_key = Chef::EncryptedDataBagItem.load("ssl-keys", default['salesforce']['domain'])

default['apache']['ssl']['chaincert'] = salesforce_ssl["chaincert"]
default['apache']['ssl']['cert'] = salesforce_ssl["cert"]
default['apache']['ssl']['key'] = salesforce_ssl_key["key"]

# mod_proxy settings
default['apache']['proxy']['deny_from']  = 'none'
default['apache']['proxy']['allow_from'] = 'all'

# oe-tomcat::default

default['tomcat']['java_options'] = '-server -Xms1024m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=256m -Djava.awt.headless=true -XX:+UseConcMarkSweepGC  -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:/var/log/tomcat7/gc.log -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false'

default['tomcat']['authbind'] = 'yes'
default['tomcat']['deploy_manager_apps'] = 'true'
default['tomcat']['port']     = '8080'

# oe-tomcat::libs
default['tomcat']['jars'] = {
  :add => [
	 {
      :name   => "catalina-jmx-remote.jar",
      :digest => "4973c02140b67e31550ddfc5fbdbd5c577888ee29153c8df0fa8430f46aade95"
     },
 ],

  :remove => [],
}

# oe-tomcat::propfiles
default['tomcat']['propfiles_prefix'] = '/opt/salesforce/env'

# oe-ssl
default['ssl']['type']    = 'keystore'
default['ssl']['owner']   = 'tomcat7'
default['ssl']['group']   = 'root'
default['ssl']['service'] = 'tomcat'


#oe-tomcat::cacerts
default['tomcat']['ssl']['certs_dir']     = '/opt/salesforce/ssl/cacerts'

#oe-ssl
default['ssl']['pem'] = {
  'prefix' => '/opt/salesforce/ssl',
}

default['ssl']['keystore'] = {
  'prefix' => '/opt/salesforce/ssl',
}

default['ssl']['pkcs12'] = {
  'prefix' => '/opt/salesforce/ssl',
}
