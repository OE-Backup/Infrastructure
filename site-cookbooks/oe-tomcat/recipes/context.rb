#
# Cookbook Name:: oe-tomcat
# Recipe:: log4j
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#
# "tomcat": { 
#   "databag":      "some_databag",
#   "databag_item": "item",
# }
#
# Databag structure:
#
# "some_databag": {
#   "item": {
#     "context_prefix": "/some/place",
#     "context": "context_file",
#     "path": "/context_file",
#     "doc_base": "/some/where/exploded/war",
#     "jdbc": {
#       "jdbc_key_1": "jdbc_value_1"
#     },
#     "memcache": {
#       "memcache_key_1": "memcache_value_1"
#     },
#     "properties": {
#      "...": "..."
#     }
#   }
# }
#

include_recipe 'oe-tomcat::service'

context = {}

context = Tomcat.databag_item(
  node['tomcat']['databag'],
  node['tomcat']['databag_item'],
  node['tomcat']['databag_encrypted']
  )['tomcat']

ctx_filename = "#{context['context_prefix'] || node['tomcat']['dirs']['config']}/#{context['context'] || 'context'}.xml" 

prefix = File.dirname(ctx_filename)

# If config directory was not created make sure it is
begin
  t = resource(directory: prefix)
  t.action :create
rescue
  directory prefix do
    action    :create
    owner     node['tomcat']['user']
    group     node['tomcat']['group']
    mode      '0750'
    recursive true
  end
end

template ctx_filename do
  action    :create
  owner     node['tomcat']['user']
  group     node['tomcat']['group']
  mode      '0640'
  source    'conf/context.xml.erb'
  notifies  :restart, "service[tomcat]", :delayed
  variables({ :context => context })
end

