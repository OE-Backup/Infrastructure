
dbi_domain = node['ssl']['fqdn'].gsub(/\./, '_')

ssl     = Chef::DataBagItem.load(node['ssl']['databag'], dbi_domain)
ssl_key = Chef::EncryptedDataBagItem.load(node['ssl']['databag_enc'], dbi_domain).to_hash

# The databag has different files (crt, ca, chain)
# ft: cert | ca | chain
# data: filename and content

# Double check the existence of required attributes
if not ssl_key.has_key?('key') then
  raise "No key found in databag"
end

if not ssl.has_key?('cert') then
  raise "No cert found in databag"
end

if not ssl.has_key?('ca') then
  raise "No cert found in databag"
end

if not ssl.has_key?('chaincert') then
  raise "No cert found in databag"
end

directory "#{node['ssl']['pem']['prefix']}/#{node['ssl']['fqdn']}" do
  action    :create
  owner     node['ssl']['owner']
  group     node['ssl']['group']
  mode      0775
  recursive true
end

# why duplicate code if this can be done ;)
ssl['key'] = ssl_key['key']

# This following three are required
[ 'key', 'cert', 'ca', 'chaincert' ].each { |f|
  file "#{node['ssl']['pem']['prefix']}/#{node['ssl']['fqdn']}/#{node['ssl']['fqdn']}.#{f}" do
    action  :create
    owner   node['ssl']['owner']
    group   node['ssl']['group']
    mode    0640
    content ssl[f]
  end
}

