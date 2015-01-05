#
# Cookbook Name:: oeinfra
# Recipe:: access_groups
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#
# This recipe enables you to add users belonging
# to a group, to another group.
# 
# It also uses pam_access to enable per group ssh access
#
# You need the following attributes structure:
#
# "access_groups": [
#   {
#     "group": "group0"
#   },
#   {
#     "group":  "group0",
#     "access": true
#   },
#   { 
#     "group":     "group1", 
#     "dst_group": "adm"
#   },
#   { 
#     "group":     "group2", 
#     "dst_group": "adm", 
#     "action":    "remove"
#   },
#   { 
#     "group":     "group3", 
#     "dst_group": "adm", 
#     "action":    "remove",
#     "access":    false
#   }
# ]
#
# The first element permits access through pam_access to group group0.
# The second case, is just a redundancy of the first one (explicitly stating
# the default action)
# 
# The third case, members from group1 will be copied to the adm group, and also
# be granted access.
#
# The forth case, will remove users from adm group, but still be granted access
#
# Finally, the last case, will disable access to services
#

at = "#{cookbook_name}::#{recipe_name}"

if node['access_groups'].nil?
  Chef::Log.warn("#{at}: No access groups defined - node['access_groups']. Only defaults will be set.") 
end

ohai 'reload' do
  action :reload
end

# Array to put ssh access groups into
access_groups = Array.new
node['oeinfra']['access_groups'].each { |g| access_groups.push(g) }

node['access_groups'].each { |g|
  
  # Make sure from and to group exist
  if node['etc']['group'][g['group']].nil?
    Chef::Log.warn("#{at}: Source group #{g['group']} does not exists ... skipping")
    next
  end
  
  # If dst_group is defined, we want to copy (or remove)
  # members from group to dst_group
  if g['dst_group']
    
    if node['etc']['group'][g['dst_group']].nil?
      Chef::Log.warn("#{at}: Destination group #{g['dst_group']} does not exists ... skipping")
      next
    end
    
    members = []
    append  = nil
    
    if g['action'].nil? || g['action'] == 'add'
      append  = true
      members = node['etc']['group'][g['group']]['members'] 
    elsif g['action'] == 'remove'
      append  = false
      members = node['etc']['group'][g['dst_group']]['members'].reject { |m|
        node['etc']['group'][g['group']]['members'].include?(m)
      }
    else
      Chef::Log.warn("#{at}: Valid actions are add|remove (default to add). Skipping")
      next
    end
    
    group g['dst_group'] do
      action  :modify
      append  append
      members members
    end
    
  end

  if (g['access'].nil? or g['access']) and not access_groups.include?(g['group'])
    access_groups.push(g['group'])
  end
} unless node['access_groups'].nil?

template '/etc/security/access.conf' do
  action :create
  source 'ldapauth/access.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  backup 1
  variables({ :access_groups => access_groups })
end

