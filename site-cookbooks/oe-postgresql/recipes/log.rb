#
# Cookbook Name:: oe-postgresql
# Recipe:: log
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

include_recipe 'oe-logs::log'
include_recipe 'oe-logs::logrotate'

