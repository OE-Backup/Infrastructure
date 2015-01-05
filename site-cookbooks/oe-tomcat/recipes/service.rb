#
# Cookbook Name:: oe-tomcat
# Recipe:: service
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#

service 'tomcat' do
  service_name "tomcat#{node['tomcat']['version']}"
  action [:enable, :start]
end

