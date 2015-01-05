#
# Cookbook Name:: oe-postgresql
# Recipe:: repmgr
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

return unless node['postgresql']['server']['replication']

# FIXME
# Right now, this is copying binary files
# already compiled. This is awfull and should
# be changed in a recipe refactor

%w{ bin/repmgr bin/repmgrd lib/repmgr_funcs.so }.each { |bin|
  cookbook_file "repmgr/#{bin}" do
    action  :create
    path    "#{node['postgresql']['prefix']['install']}/#{bin}"
    source  "repmgr/#{bin}"
    owner   'root'
    group   'root'
    mode    0755
  end
}

%w{ repmgr/sql/repmgr_funcs.sql }.each { |f|
  cookbook_file f do
    action  :create
    path    "#{node['postgresql']['prefix']['scripts_sql']}/#{f.split('/').last}"
    source  f
    owner   'root'
    group   'root'
    mode    0644
  end
}

# If node id is not defined, try to guess it from the node name
if node['repmgr']['config']['node'].nil?
  case node['postgresql']['server']['type']
    when 'master' then node.default['repmgr']['config']['node'] = 1
    when 'slave'  then node.default['repmgr']['config']['node'] = 2
    when 'ro'     then node.default['repmgr']['config']['node'] = 3
    else
      Chef::Log.warn('Could not guess repmgr node id from node name')
  end
end

# Verify if we have to define any defaults
node['repmgr']['defaults']['config'].each { |k, v|
  if node['repmgr']['config'][k].nil? then
    node.override['repmgr']['config'][k] = v
  end
}

# Verify that required attributes are set
node['repmgr']['required'].each { |k, v|
  if node['repmgr']['config'][k].nil? then
    f = "#{cookbook_name}::#{recipe_name}"
    raise "#{f}: Attribute node['repmgr']['config'][#{k}] should be set"
  end
}

template "#{node['postgresql']['prefix']['cfg']}/repmgr.conf" do 
  action  :create
  source  'repmgr.conf.erb'
  owner   node['postgresql']['user']['name']
  group   node['postgresql']['group']['name']
  mode    0640
end

