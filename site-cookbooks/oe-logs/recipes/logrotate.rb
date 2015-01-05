#
# Cookbook Name:: oe-logs
# Recipe:: logrotate
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#
# Attributes
#
#   node['logrotate']['services'] = {
#     'tomcat'   => { ... },
#     'postgres' => { ... },
#   }
#
#   Configuration Hash:
#   {
#     'logfile':        <str>,
#     'interval':       '(hourly|daily|weekly|monthly|yearly)',
#     'rotate_count':   int,
#     'owner':          <user>,
#     'group':          <group>,
#   }


node['oe-logs']['services'].each { |svc, conf|
  
  return if node['oe-logs']['services'][svc]['logrotate'].nil?

  conf_d = node['oe-logs']['logrotate']['prefix']

  template "#{conf_d}/#{svc}" do
    action    :create
    owner     'root'
    group     'root'
    mode      0644
    source    'logrotate.conf.erb'
    variables({ :service => svc, :cfg => conf['logrotate'] })
  end
}

