#
# Cookbook Name:: pp2-store2
# Recipe:: default
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#

#include_recipe 'oeinfra::apt'
#include_recipe 'oe-tomcat::ssl'
include_recipe 'oe-tomcat'
include_recipe 'oe-tomcat::propfiles'
include_recipe 'oe-tomcat::log'
include_recipe 'oe-tomcat::cacerts'

