#
# Cookbook Name:: oe-logs
# Recipe:: default
#
# Copyleft 
#
# Modify, redistribute, it's Free Software
#
include_recipe 'oe-logs::log'
include_recipe 'oe-logs::logrotate'
