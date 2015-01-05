#
# Cookbook Name:: lp2-db
# Recipe:: datadog
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
lp2_settings = Chef::DataBagItem.load("lp2", "settings")
lp2_secrets  = Chef::EncryptedDataBagItem.load('lp2', 'secrets')

# this is supposed to only work on production, since it's the only environment
# monitored with datadog, for that reason only in the production section of the
# data bag are defined the datadog attributes

node.default['datadog']['api_key'] = lp2_secrets[node.chef_environment.to_s]['datadog']['api_key']
node.default['datadog']['application_key'] = lp2_secrets[node.chef_environment.to_s]['datadog']['application_key']
node.set['datadog']['monitor_role'] = lp2_settings[node.chef_environment.to_s]['datadog']['db_monitor_role']
node.set['datadog']['monitor_pass'] = lp2_secrets[node.chef_environment.to_s]['datadog']['db_monitor_pass']

include_recipe 'datadog::dd-agent'

node.normal['datadog']['postgres']['instances'] = [
  {
    'server' => 'localhost',
    'port' => 5432,
    'username' => node['datadog']['monitor_role'],
    'password' => node['datadog']['monitor_pass']
  }
]

include_recipe 'datadog::postgres'
