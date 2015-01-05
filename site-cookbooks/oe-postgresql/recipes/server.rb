#
# Cookbook Name:: oe-postgresql
# Recipe:: server
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

include_recipe 'oe-postgresql::apt'

# Package installation
node['postgresql']['server']['packages'].each { |pkg|
  package "#{pkg}-#{node['postgresql']['version']}" do
    action  :install
  end
}

#group node['postgresql']['group']['name'] do
#  action  :create
#  gid     node['postgresql']['group']['gid']
#  system  true
#end
#
#user node['postgresql']['user']['name'] do
#  action  :create
#  uid     node['postgresql']['user']['uid']
#  gid     node['postgresql']['group']['gid']
#  home    node['postgresql']['user']['home']
#  comment node['postgresql']['user']['gecos']
#  system  true
#end

# Set some environment variables
template "#{node['postgresql']['user']['home']}/.profile" do
  action  :create
  source  'profile.erb'
  owner   node['postgresql']['user']['name']
  mode    0644
end

service 'postgresql' do
  action      [ :nothing, :enable ]
  subscribes  :stop, "package[postgresql-#{node['postgresql']['version']}]", :immediately
end

# Set some defaults if they are not defined already
default_cfg = node['postgresql']['defaults']['config']
default_cfg.keys.each { |section|
  default_cfg[section].each { |k,v| 
    if node['postgresql']['config'][section][k].nil? then
      node.override['postgresql']['config'][section][k] = v
    end
  }
}

# Verify that required parameters are set
required_cfg = node['postgresql']['required']
required_cfg.keys.each { |section|
  required_cfg[section].each { |k|
    if node['postgresql']['config'][section][k].nil? then
      raise "#{cookbook_name}::#{recipe_name}: Missing required attribute: ['postgresql']['config']['#{section}']['#{k}']"
    end
  }
}

# If we are setting up config files, we should always 
# create (or verify) that the prefix exists
node['postgresql']['prefix'].each { |desc, prefix_dir|
  begin
    resources(:directory => prefix_dir)
    #Chef::Log.warn("#{cookbook_name}::#{recipe_name}: Resource directory[#{prefix_dir}] already exists")
  rescue Chef::Exceptions::ResourceNotFound
    directory prefix_dir do
      action    :create
      owner     node['postgresql']['user']['name']
      group     node['postgresql']['group']['name']
      recursive true
    end
  end
}

