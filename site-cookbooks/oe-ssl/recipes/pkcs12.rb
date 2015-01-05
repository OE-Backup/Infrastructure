
include_recipe 'oe-ssl::pem'

dbi_domain = node['ssl']['fqdn'].gsub(/\./, '_')

ssl     = Chef::DataBagItem.load(node['ssl']['databag'], dbi_domain)
ssl_key = Chef::EncryptedDataBagItem.load(node['ssl']['databag_enc'], dbi_domain).to_hash

# Double check the existence of required attributes
if not ssl_key.has_key?('key') then
  raise "No key found in databag"
end

if not ssl.has_key?('cert') then
  raise "No cert found in databag"
end

if not ssl.has_key?('chaincert') then
  raise "No cert found in databag"
end

# Some shortcuts 
fqdn       = node['ssl']['fqdn']
prefix_pem = node['ssl']['pem']['prefix']
prefix_p12 = node['ssl']['pkcs12']['prefix']

# This directory could be different from the ones on the other
# recipes, but if it isn't it'll throw a warning. This will keep
# that warning off
unless resources(:directory => "#{prefix_pem}/#{fqdn}") then
  directory "#{prefix_pem}/#{fqdn}" do
    action    :create
    owner     node['ssl']['owner']
    group     node['ssl']['group']
    mode      0775
    recursive true
  end
end

cert    = "#{prefix_pem}/#{fqdn}/#{fqdn}.cert"
key     = "#{prefix_pem}/#{fqdn}/#{fqdn}.key"
ca      = "#{prefix_pem}/#{fqdn}/#{fqdn}.ca"
chain   = "#{prefix_pem}/#{fqdn}/#{fqdn}.chaincert"
cacerts = "#{prefix_p12}/#{fqdn}/ca-chain.pem"
pkcs12  = "#{prefix_p12}/#{fqdn}/#{fqdn}.p12"

raise "Certificate container password is not set" unless not ssl_key['keystorePass'].nil?

# Expose this variables as attributes for usage in other recipes
node.set_unless['ssl'][node['ssl']['service']]['pkcs12'] = "#{pkcs12}"
#node.set_unless['ssl'][node['ssl']['service']]['keyPass']      = "#{ssl_key['keyPass']}"
node.set_unless['ssl'][node['ssl']['service']]['pkcs12'] = "#{ssl_key['keystorePass']}"

# Include ca and chain in one file
file cacerts do
    action      :create
    owner       node['ssl']['owner']
    group       node['ssl']['group']
    mode        0640
    content     "#{ssl['ca']}\n#{ssl['chaincert']}"
end

# This resource generates the keystore, based on
# the previously created pkcs12 container. By default
# it won't be executed (action :nothing), unless the
# pkcs12 changes (subscribe :run, 'file[]').
execute "create-PKCS12-#{fqdn}" do
  action  :nothing
  cwd     "#{prefix_p12}/#{fqdn}"
  umask   0002
  command <<-EOC
      openssl pkcs12 \
        -export \
        -inkey  #{key}      \
        -in     #{cert}     \
        -CAfile #{cacerts}  \
        -out    #{pkcs12}   \
        -chain              \
        -password pass:#{ssl_key['keystorePass']} 
  EOC
  subscribes :run, "file[#{key}]",      :delayed
  subscribes :run, "file[#{cert}]",     :delayed
  subscribes :run, "file[#{cacerts}]",  :delayed
end

