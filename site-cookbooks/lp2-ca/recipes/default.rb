#
# Cookbook Name:: lp2-ca
# Recipe:: default
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#

include_recipe 'oeinfra::apt'
include_recipe 'oe-ssl'
include_recipe 'oe-tomcat'
include_recipe 'lp2-ca::apache'

