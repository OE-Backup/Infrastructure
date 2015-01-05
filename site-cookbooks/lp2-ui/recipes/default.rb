#
# Cookbook Name:: lp2-ui
# Recipe:: default
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "lp2-ui::apt"
include_recipe "oe-ssl"
include_recipe "lp2-ui::apache"
include_recipe "lp2-ui::tomcat"
