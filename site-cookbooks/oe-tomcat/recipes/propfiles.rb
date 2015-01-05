#
# Cookbook Name:: oe-tomcat 
# Recipe:: propfiles
#
# Required attributes:
#   - src
#
# Optional attributes>
#   - dst: env | context (defaults to env)
#   - databag_item: existing item on a databag from where to get key-value pairs
#
# Usage:
#   In the following examples, the first one is a file that will be loaded as
#   environment variables, from /etc/default/tomcat7.
#
#   The second one, will be loaded from the context.xml file, as a java 
#   properties file.
#
#   On both cases, the files will be loaded from a databag.
#
#   The third case, will be a file loaded as en environment file (default), but 
#   its content will not be managed from chef.
#
#   The databag item ('tomcat_properties', 'db_item') should contains
#   keys (variable names) and its corresponding values.
#
# Example:
#
# "tomcat": {
#   "propfiles": [
#     { 
#       "src": "file1",
#       "dst": "env",
#       "databag_item": "pp2"
#     },
#     { 
#       "src": "file2",
#       "dst": "context",
#       "databag_item": "pp2"
#     },
#     { 
#       "src": "file3",
#     }
#
#   ]
# }
#

dbi = Tomcat.databag_item(
  node['tomcat']['databag'],
  node['tomcat']['databag_item'],
  node['tomcat']['databag_encrypted']
  )
  
properties        = dbi['tomcat']['properties']        || nil
properties_prefix = dbi['tomcat']['properties_prefix']

# This attribute should be defined at a role / environment level
return if properties.nil? or properties.empty?

# Make sure the prefix for propfiles exists
directory properties_prefix do
  action  :create
  owner   node['tomcat']['owner']
  group   node['tomcat']['group']
  mode    '2770'
end

# Select files that are to be built from data bags
from_databag = properties.select { |f| not f['databag_item'].nil? }

comment_ctx = "<!-- Chef generated property file -->\n"
comment_env = "# Chef generated property file\n"

from_databag.each { |f|

 # Get the environment (<app>-<env>) => <env>
  environment = node.chef_environment.split('-')[1]

  dbi     = Chef::EncryptedDataBagItem.load('tomcat_properties', f['databag_item']).to_hash
  dbi_env = dbi[environment]

  cnt  = f.include?('dst') && f['dst'] == 'context' ?  comment_ctx : comment_env
  cnt += dbi_env.map { |k,v| "#{k}=#{v}" }.join("\n")
  
  file "#{properties_prefix}/#{f['src']}" do
    action    :create
    owner     node['tomcat']['owner']
    group     node['tomcat']['group']
    mode      0640
    content   cnt
    notifies  :restart, "service[tomcat]", :delayed
  end
}

