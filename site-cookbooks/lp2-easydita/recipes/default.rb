#
# Cookbook Name:: lp2-easydita
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "lp2-easydita::apt"
include_recipe "lp2-easydita::apache"
include_recipe "lp2-easydita::tomcat"
