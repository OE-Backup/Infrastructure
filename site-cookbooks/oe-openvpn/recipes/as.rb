#
# Cookbook Name:: oe-openvpn
# Recipe:: as
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute
#
# This recipe setup a OpenVPN Access Server
# It depends on the AMIs provided by openvpn.net 
# http://docs.openvpn.net/how-to-tutorialsguides/virtual-platforms/amazon-ec2-appliance-ami-quick-start-guide/

# This populates the Duo Security installer with the relevant keys
duokeys = Chef::EncryptedDataBagItem.load('third-party', 'duokeys')

# This is needed to input some neccessary administration credentials
oeinfra = Chef::EncryptedDataBagItem.load('oeinfra', 'secrets')

# This loads ssl information for a given environment
ssl      = Chef::DataBagItem.load('ssl', node['ssl']['fqdn'].sub(/\./, '_'))
ssl_keys = Chef::EncryptedDataBagItem.load('ssl-keys', node['ssl']['fqdn'].sub(/\./, '_'))
node.set['oe-openvpn']['as']['cs.ca_bundle'] = ssl['chaincert']
node.set['oe-openvpn']['as']['cs.cert']      = ssl['cert']
# private key data is available in ssl_keys['key']

package 'openssl'
openvpn_admin_hashed_password = `openssl passwd -1 #{oeinfra['openvpn']['as']['admin_pw']}`.chomp

# enable access to administrative user
user node['oe-openvpn']['as']['admin_user'] do
  action   :modify
  password openvpn_admin_hashed_password
end

# install duo security plugin
execute 'installduo' do
  command './sacli -k auth.module.post_auth_script --value_file=./duo_openvpn_as.py ConfigPut > /var/log/duoinstalled.log'
  creates '/var/log/duoinstalled.log'
  action  :nothing
  cwd     '/usr/local/openvpn_as/scripts/'
  user    'root'
end

# needed to reset the server so it can notice configuration changes
execute 'saclireset' do
  command './sacli reset'
  action  :nothing
  cwd     '/usr/local/openvpn_as/scripts/'
  user    'root'
end

# duo security plugin template
template '/usr/local/openvpn_as/scripts/duo_openvpn_as.py' do
  only_if { node['oe-openvpn']['as']['use_duo_security'] }
  source 'duo_openvpn_as.py.erb'
  variables({
    :IKEY => duokeys['IKEY'],
    :SKEY => duokeys['SKEY'],
    :HOST => duokeys['HOST']
  })
  notifies :run, resources(:execute => 'installduo')
  notifies :run, resources(:execute => 'saclireset')
end

if defined?(node['oe-infra']['provisioning']['domain'])
  node.set['oe-openvpn']['as']['host.name'] = node.name + '.' + node['oe-infra']['provisioning']['domain']
end

# Set configuration keys if unset
%w{
  host.name
  cs.cert cs.ca_bundle
  vpn.daemon.0.client.netmask_bits  vpn.daemon.0.client.network
  vpn.daemon.0.listen.ip_address    vpn.daemon.0.listen.port
  vpn.daemon.0.listen.protocol      vpn.daemon.0.server.ip_address
}.each { |directive|
  bash "setup-#{directive}" do
    code <<-EOH
      ./sacli \
        --key '#{directive}' \
        --value '#{node['oe-openvpn']['as'][directive]}' \
        ConfigPut
    EOH
    cwd       '/usr/local/openvpn_as/scripts/'
    user      'root'
    not_if    "/usr/local/openvpn_as/scripts/sacli ConfigQuery | grep '#{directive}\": \"#{node['oe-openvpn']['as'][directive]}\"'"
    notifies  :run, resources(:execute => 'saclireset'), :delayed
  end
}

bash "setup-cs.priv_key" do
  code <<-EOH
    ./sacli \
      --key 'cs.priv_key' \
      --value '#{ssl_keys['key']}' \
      ConfigPut
  EOH
  cwd       '/usr/local/openvpn_as/scripts/'
  user      'root'
  not_if    "/usr/local/openvpn_as/scripts/sacli ConfigQuery | grep 'cs.priv_key\": \"#{ssl_keys['key']}\"'"
  notifies  :run, resources(:execute => 'saclireset'), :delayed
end

# add routes to private networks to be access through this openvpn server
node['oe-openvpn']['as']['private_networks'].count.times do |i|
  execute 'setup-routing-to-private-network-' + i.to_s do
    command "./sacli --key 'vpn.server.routing.private_network.#{i.to_s}' --value '#{node['oe-openvpn']['as']['private_networks'][i]}' ConfigPut"
    cwd      '/usr/local/openvpn_as/scripts/'
    user     'root'
    notifies :run, resources(:execute => 'saclireset'), :delayed
    not_if   "/usr/local/openvpn_as/scripts/sacli ConfigQuery | grep 'vpn.server.routing.private_network.#{i.to_s}\": \"#{node['oe-openvpn']['as']['private_networks'][i]}\"'"
  end
end

# optional: add ldap authentication settings
if node['oe-openvpn']['as']['auth.module.type'].eql?('ldap')
  %w{
    auth.module.type
    auth.ldap.0.add_req               auth.ldap.0.bind_dn
    auth.ldap.0.name                  auth.ldap.0.server.0.host
    auth.ldap.0.server.1.host         auth.ldap.0.ssl_verify
    auth.ldap.0.timeout               auth.ldap.0.uname_attr
    auth.ldap.0.use_ssl               auth.ldap.0.users_base_dn
  }.each { |directive|
    bash "setup-#{directive}" do
      code <<-EOH
        ./sacli \
          --key '#{directive}' \
          --value '#{node['oe-openvpn']['as'][directive]}' \
          ConfigPut
      EOH
      cwd       '/usr/local/openvpn_as/scripts/'
      user      'root'
      not_if    "/usr/local/openvpn_as/scripts/sacli ConfigQuery | grep '#{directive}\": \"#{node['oe-openvpn']['as'][directive]}\"'"
      notifies  :run, resources(:execute => 'saclireset'), :delayed
    end
  }

  # Setup Ldap password
  bash "setup-auth.ldap.0.bind_pw" do
    code <<-EOH
      ./sacli \
        --key 'auth.ldap.0.bind_pw' \
        --value '#{oeinfra['ldapauth']['bind_pw']}' \
        ConfigPut
    EOH
    cwd       '/usr/local/openvpn_as/scripts/'
    user      'root'
    not_if    "/usr/local/openvpn_as/scripts/sacli ConfigQuery | grep 'auth.ldap.0.bind_pw\": \"#{oeinfra['ldapauth']['bind_pw']}\"'"
    notifies  :run, resources(:execute => 'saclireset'), :delayed
  end

end

