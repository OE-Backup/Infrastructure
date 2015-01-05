#
# Cookbook Name:: pp2-ps
# Recipe:: default
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#

#include_recipe 'oeinfra::apt'
include_recipe 'oe-tomcat'
include_recipe 'oe-tomcat::propfiles'
include_recipe 'oe-tomcat::default'
include_recipe 'oe-tomcat::cacerts'



