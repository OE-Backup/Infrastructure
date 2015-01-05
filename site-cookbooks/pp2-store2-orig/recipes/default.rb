#
# Cookbook Name:: pp2-store2
# Recipe:: default
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "pp2-store2::apt"
include_recipe "pp2-store2::apache"
include_recipe "pp2-store2::tomcat"
