#
# Cookbook Name:: oe-monitoring
# Recipe:: loggly
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#
# In the environment definition:
#
# "monitoring": {
#   "loggly": {
#     "enabled": true,
#   }
# }
#
# On the role definition:
#
# "monitoring": {
#   "loggly": {
#     "services": {
#       "tomcat": {
#         "filename":     "/path/to/logfile", # Log file to send to loggly
#         "tags":         [ "tag1" ],         # Optional, List of tags.
#         "filetag":      "service",          # Optional, defaults to service name
#         "statefile":    "host-service",     # Optional, must be uniq. Defaults to host-service
#         "severity":     "info",             # Optional
#         "pollinterval": 1                   # Optional
#         "priority":     99,                 # Optional, Rsyslog load priority. Defaults to 99
#       },
#       "dotcms": {
#         ...
#       }
#     }
#   }
# }
#

return unless node['monitoring']['loggly']['enabled']

#include_attribute 'oe-monitoring::loggly'

begin
  s = resources(:service => 'rsyslog')
  s.action :nothing
rescue
  service 'rsyslog' do
    action :nothing
  end
end

loggly_id = Chef::EncryptedDataBagItem.load(
  node['monitoring']['databag'], 
  node['monitoring']['databag_item']
).to_hash()[node.chef_environment.split('-').last]['id']

node['monitoring']['loggly']['services'].each { |svc, c|
  
  cfg = Hash.new
  c.each_pair { |k,v| cfg[k] = v }
  
  cfg['filetag']      ||= svc
  cfg['statefile']    ||= "#{node.name}-#{svc}"
  cfg['severity']     ||= 'info'
  cfg['pollinterval'] ||= 1
  cfg['priority']     ||= 99
  cfg['tags']           = Array(cfg['tags']).concat(
    [node.name, node.chef_environment]
  ).join('\" tag=\"')
  cfg['server']         = node['monitoring']['loggly']['server']

  template "#{node['monitoring']['loggly']['prefix']}/#{cfg['priority']}-#{svc}.conf" do
    action    :create
    owner     'root'
    group     'root'
    mode      0644
    source    'rsyslog-loggly.conf.erb'
    notifies  :restart, 'service[rsyslog]', :delayed
    variables({ 
      :service   => svc, 
      :cfg       => cfg,
      :loggly_id => loggly_id
    })
  end
}

