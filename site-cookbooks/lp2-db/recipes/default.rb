#
# Cookbook Name:: lp2-db
# Recipe:: default
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute

include_recipe 'lp2-db::engine-settings'
include_recipe 'lp2-db::apt'
include_recipe 'lp2-db::postgresql'
include_recipe 'lp2-db::postfix'
include_recipe 'lp2-db::postgres-user'
include_recipe 'lp2-db::repmgr'
