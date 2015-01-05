#
# Cookbook Name:: lp2-tp
# Recipe:: default
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "lp2-tp::apt"
include_recipe "lp2-tp::apache"
include_recipe "lp2-tp::tomcat"
