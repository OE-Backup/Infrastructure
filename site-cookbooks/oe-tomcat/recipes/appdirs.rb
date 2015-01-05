#
# Cookbook Name:: oe-tomcat
# Recipe:: appdirs
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#
# "tomcat": {
#   "appdirs": [
#     {
#       "path"  => "/some/dir",
#       "owner" => "user1",  # optional
#       "group" => "group1", # optional
#       "mode"  => "0755",   # optional
#     },
#     {
#       "type"  => "symlink",
#       "path"  => "/some/symlink",
#       "dest"  => "/a/real/directory"
#     }
#   ]
# }
# 

return if node['tomcat']['appdirs'].nil?

at = "#{cookbook_name}::#{recipe_name}"

app_dirs = node['tomcat']['appdirs'].dup

app_dirs.each { |d|
  
  d['type'] ||= 'directory'

  if d['type'] == 'directory'
    directory d['path'] do
      action    :create
      owner     d['owner'] || node['tomcat']['user']
      group     d['group'] || node['tomcat']['group']
      mode      d['mode']  || '0750'
      recursive true
    end

  elsif d['type'] == 'symlink'
    if d['dest'].nil?
      Chef::Log.warn("#{at}: If type is symlink, you must define 'dest' attribute. Skipping.")
      next
    end
    link d['path'] do
      action    :create
      to        d['dest']
      owner     d['owner'] || node['tomcat']['user']
      group     d['group'] || node['tomcat']['group']
    end
  
  else
    Chef::Log.warn("#{at}: Valid types are: directory|symlink. Defaults to directory")
    next
  end

}

