#
# Cookbook Name:: pp2-store2
# Recipe:: datadog
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
oeinfra_secrets  = Chef::EncryptedDataBagItem.load("oeinfra", "secrets")

# this is supposed to only work on production, since it's the only environment
# monitored with datadog, for that reason only in the production section of the
# data bag are defined the datadog attributes

node.default['datadog']['api_key'] = oeinfra_secrets["datadog"][node.chef_environment.to_s.split("-").last]["api_key"]
node.default['datadog']['application_key'] = oeinfra_secrets["datadog"][node.chef_environment.to_s.split("-").last]['application_key']

include_recipe 'datadog::dd-agent'

#to-do: retrive jmx port from an attribute
node.normal['datadog']['tomcat']['instances'] = [
  {
    :server => 'localhost',
    :port => '39193',
    :name => node.name.downcase.gsub(/_/, '-')
  }
]

include_recipe 'datadog::tomcat'

node.normal['datadog']['apache']['instances'] = [
  {
    'status_url' => 'http://localhost:81/server-status?auto'
  }
]

include_recipe 'datadog::apache'
