#
# Cookbook Name:: oe-tomcat
# Recipe:: log4j
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#
# "tomcat": {
#   "log4j": {
#     "filename": "/some/place",
#     "owner":    "tomcat7",    # optional
#     "group":    "tomcat7",    # optional
#     "mode":     "0644",       # optional
#     "appenders": [
#       {
#         "name":  "someAppender",
#         "file":  "/some/place/to/log",
#         "class": "some.class",   # optional: (org.apache.log4j.DailyRollingFileAppender)
#         "file_pattern": "",      # optional: ('')
#         "layout_class":   "..."  # optional: (org.apache.log4j.PatternLayout)
#         "layout_pattern": "..."  # optional: ('%d{ISO8601}  %-5p: %c - %m%n')
#       } 
#     ],
#     "loggers": {
#       "class.name": {
#         "level": "WARN" # TRACE|DEBUG|INFO|WARN|ERROR|FATAL
#       }
#     }
#   }
# }
# 

return if node['tomcat']['log4j'].nil? or node['tomcat']['log4j']['filename'].nil?

prefix = File.dirname(node['tomcat']['log4j']['filename'])

# If log4j directory was not created, make sure it is
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


template node['tomcat']['log4j']['filename'] do
  action  :create
  owner   node['tomcat']['log4j']['owner'] || node['tomcat']['user']
  group   node['tomcat']['log4j']['group'] || node['tomcat']['group']
  mode    node['tomcat']['log4j']['mode']  || '0644'
  source  'conf/log4j.xml.erb'
  variables({ 
    :appenders => node['tomcat']['log4j']['appenders'] || [],
    :loggers   => node['tomcat']['log4j']['loggers']   || {} 
  })
end

