
include_recipe 'oe-ssl::pem'
include_recipe 'oe-ssl::pkcs12'

dbi_domain = node['ssl']['fqdn'].gsub(/\./, '_')

ssl     = Chef::DataBagItem.load(node['ssl']['databag'], dbi_domain)
ssl_key = Chef::EncryptedDataBagItem.load(node['ssl']['databag_enc'], dbi_domain).to_hash

# Some shortcuts 
fqdn       = node['ssl']['fqdn']
prefix_pem = node['ssl']['pem']['prefix']
prefix_p12 = node['ssl']['pkcs12']['prefix']
prefix_jks = node['ssl']['keystore']['prefix']

# This directory could be different from the ones on the other
# recipes, but if it isn't it'll throw a warning. This will keep
# that warning off
unless resources(:directory => "#{prefix_jks}/#{fqdn}") then
  directory "#{prefix_jks}/#{fqdn}" do
    action    :create
    owner     node['ssl']['owner']
    group     node['ssl']['group']
    mode      0775
    recursive true
  end
end

cert     = "#{prefix_pem}/#{fqdn}/#{fqdn}.cert"
key      = "#{prefix_pem}/#{fqdn}/#{fqdn}.key"
ca       = "#{prefix_pem}/#{fqdn}/#{fqdn}.ca"
keystore = "#{prefix_jks}/#{fqdn}/#{fqdn}.jks"

raise "Certificate container password is not set" unless not ssl_key['keystorePass'].nil?

# Expose this variables as attributes for usage in other recipes
node.set_unless['ssl'][node['ssl']['service']]['keystore']     = "#{keystore}"
#node.set_unless['ssl'][node['ssl']['service']]['keyPass']      = "#{ssl_key['keyPass']}"
node.set_unless['ssl'][node['ssl']['service']]['keystorePass'] = "#{ssl_key['keystorePass']}"

#Chef::Log.warn(node['ssl'][node['ssl']['service']['keystore']])

# This resource generates the keystore, based on
# the previously created pkcs12 container. By default
# it won't be executed (action :nothing), unless the
# pkcs12 changes (subscribe :run, 'file[]').
execute "create-Keystore-#{fqdn}" do
  action  :nothing
  cwd     "#{prefix_jks}/#{fqdn}"
  umask   0002
  command <<-EOC
      keytool -importkeystore \
        -noprompt \
        -srcstoretype PKCS12 \
        -srcstorepass  '#{ssl_key['keystorePass']}' \
        -srckeystore   #{prefix_p12}/#{fqdn}/#{fqdn}.p12 \
        -deststoretype JKS \
        -deststorepass '#{ssl_key['keystorePass']}' \
        -destkeystore  #{keystore}
  EOC
  subscribes :run, "execute[create-PKCS12-#{fqdn}]", :delayed
end

