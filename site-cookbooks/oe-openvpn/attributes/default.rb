default['oe-openvpn']['as']['admin_user'] = 'openvpn'

default['oe-openvpn']['as']['use_duo_security'] = true
default['oe-openvpn']['as']['host.name']        = node[:ipaddress]

default['oe-openvpn']['as']['vpn.daemon.0.client.netmask_bits'] = '24'
default['oe-openvpn']['as']['vpn.daemon.0.client.network']      = '192.168.177.0'
default['oe-openvpn']['as']['vpn.daemon.0.listen.ip_address']   = 'eth0'
default['oe-openvpn']['as']['vpn.daemon.0.listen.port']         = '443'
default['oe-openvpn']['as']['vpn.daemon.0.listen.protocol']     = 'tcp'
default['oe-openvpn']['as']['vpn.daemon.0.server.ip_address']   = 'eth0'
default['oe-openvpn']['as']['private_networks']                 = []

default['oe-openvpn']['as']['auth.module.type'] = "local"

# Those settings are only applyable when
# node['oe-openvpn']['as']['auth.module.type'].eql?('ldap') is true
default['oe-openvpn']['as']['auth.ldap.0.add_req']       = 'IsmemberOf=cn=vpn,ou=Group,dc=openenglish,dc=com'
default['oe-openvpn']['as']['auth.ldap.0.bind_dn']       = 'cn=integration_openvpn,ou=Service,dc=openenglish,dc=com'
default['oe-openvpn']['as']['auth.ldap.0.name']          = 'My LDAP servers'
default['oe-openvpn']['as']['auth.ldap.0.server.0.host'] = 'opendj1-i.oe-sys.com:1389'
default['oe-openvpn']['as']['auth.ldap.0.server.1.host'] = 'opendj2-i.oe-sys.com:1389'
default['oe-openvpn']['as']['auth.ldap.0.ssl_verify']    = 'never'
default['oe-openvpn']['as']['auth.ldap.0.timeout']       = '4'
default['oe-openvpn']['as']['auth.ldap.0.uname_attr']    = 'cn'
default['oe-openvpn']['as']['auth.ldap.0.use_ssl']       = 'never'
default['oe-openvpn']['as']['auth.ldap.0.users_base_dn'] = 'ou=People,dc=openenglish,dc=com'
