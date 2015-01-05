#
# Cookbook Name:: oe-jenkins
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "jenkins::master"

node['oe-jenkins']['plugins'].each do |plugin|
  jenkins_plugin plugin
end

%w(openjdk-7-jdk maven).each do |pkg|
  package pkg
end
