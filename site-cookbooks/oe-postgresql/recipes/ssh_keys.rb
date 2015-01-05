#
# Cookbook Name:: oe-postgresql
# Recipe:: ssh_keys
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#
# Add Users SSH public keys and private key. 
#
# Attributes:
#   - node['postgresql']['ssh_keys']['data_bag'] (defaults to 'ssh_keys')
#   - node['postgresql']['ssh_keys']['user']     nil
#
# Based on the attribute node['postgresql']['ssh_keys']['groups'], this recipe
# will iterate through members and if a data bag item exists for that
# user, then it will add it's private key (if defined) and all the public
# keys present. 
# A databag item represents a user, and its structure should be:
#
# {
#   "id": "user_name",
#   "private_key": "------BEGIN PRIVATE...",
#   "auth_keys": [
#     "ssh-rsa <public key1> user1",
#     "ssh-rsa <public key2> user2"
#   ]
# }
#

return if node['postgresql']['ssh_keys'].nil? 
return if node['postgresql']['ssh_keys']['databag'].nil?
return if node['postgresql']['ssh_keys']['user'].nil?

Chef::Log.warn(node['postgresql']['ssh_keys'])

u = node['postgresql']['ssh_keys']['user']

if node['disable_encrypted_databags'].nil? or not node['disable_encrypted_databags']
  dbi = Chef::EncryptedDataBagItem.load(
    node['postgresql']['ssh_keys']['databag'], 
    u
  )
else
  dbi = Chef::DataBagItem.load(
    node['postgresql']['ssh_keys']['databag'], 
    u
  )
end

ssh_keys = dbi.to_hash

ohai 'reload-passwd' do
  action :reload
  plugin 'passwd'
end

ohai 'reload-group' do
  action :reload
  plugin 'group'
end

directory "#{u}-ssh-directory" do
  path      lazy { "#{node['etc']['passwd'][u]['dir']}/.ssh" }
  owner     u
  mode      0700
  action    :create
end

# If there's a private key, add it
unless ssh_keys['private_key'].nil? then
  private_key = ssh_keys['private_key']
  
  file "#{u}-ssh-id_rsa" do
    path   lazy { "#{node['etc']['passwd'][u]['dir']}/.ssh/id_rsa" }
    action :create
    owner   u
    mode    0600
    content private_key
  end
end
 
auth_keys = ''
ssh_keys['authorized_keys'].each { |pubkey| auth_keys <<= "#{pubkey}\n" }

file "#{u}-ssh-auth-keys" do
  path   lazy { "#{node['etc']['passwd'][u]['dir']}/.ssh/authorized_keys" }
  action :create
  owner   u
  mode    0600
  content auth_keys
end

node['postgresql']['cluster']['hosts'].each { |h|
  ssh_known_hosts_entry h
} unless node['postgresql']['cluster'].nil? or node['postgresql']['cluster']['hosts'].nil?


