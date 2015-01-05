#
# Cookbook Name:: oe-postgresql
# Recipe:: default
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

include_recipe 'oe-postgresql::sysctl'
include_recipe 'oe-postgresql::server'
include_recipe 'oe-postgresql::log'
include_recipe 'oe-postgresql::ssh_keys'
include_recipe 'oe-postgresql::pgpass'
include_recipe 'oe-postgresql::server_type'

