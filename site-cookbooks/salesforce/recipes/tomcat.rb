#
# Cookbook Name:: pp2-store2
# Recipe:: default
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
#include_recipe 'oe-tomcat'
#include_recipe 'oe-tomcat::propfiles'
include_recipe 'java'
include_recipe 'oe-tomcat::packages'
include_recipe 'oe-tomcat::service'
include_recipe 'oe-tomcat::config'
include_recipe 'oe-tomcat::users'
include_recipe 'oe-tomcat::log'
include_recipe 'oe-tomcat::libs'
include_recipe 'oe-tomcat::probe'
include_recipe 'oe-tomcat::log4j'
include_recipe 'oe-tomcat::appdirs'
include_recipe 'oe-tomcat::log'
#include_recipe 'oe-tomcat::cacerts'
