#
# Cookbook Name:: oe-amq
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'oe-amq::amq' 
include_recipe 'oe-logs::logrotate'
include_recipe 'oe-logs::log'
