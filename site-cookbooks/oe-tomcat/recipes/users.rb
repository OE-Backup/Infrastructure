#
# Cookbook Name:: oe-tomcat
# Recipe:: users
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#

tomcat_users = Tomcat.users(
  node['tomcat']['users']['databag'],
  nil,
  node['tomcat']['databag_encrypted']
)

tomcat_roles = Tomcat.roles(
  node['tomcat']['users']['databag'],
  node['tomcat']['databag_encrypted']
)

template "#{node['tomcat']['dirs']['config']}/tomcat-users.xml" do
  action    :create
  source    'conf/tomcat-users.xml.erb'
  owner     node['tomcat']['user']
  group     node['tomcat']['group']
  mode      0640
  variables({ :tomcat_users => tomcat_users, :tomcat_roles => tomcat_roles })
  notifies  :restart, "service[tomcat]", :delayed
end

