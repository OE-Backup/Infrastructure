#
# Cookbook Name:: website2-dotcms
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"
include_recipe "website2-dotcms::dotcms"
include_recipe 'oe-logs::default'
