#
# Cookbook Name:: oe-infosec
# Recipe:: default
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute
#
#unless not node.chef_environment.to_s.split("-").last == "prd"
include_recipe "oe-infosec::auditd"
include_recipe "oe-infosec::rsyslog"
include_recipe "oe-infosec::samhain"
#end
