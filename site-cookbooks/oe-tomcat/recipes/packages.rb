#
# Cookbook Name:: oe-tomcat
# Recipe:: packages
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#

node['tomcat']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end


