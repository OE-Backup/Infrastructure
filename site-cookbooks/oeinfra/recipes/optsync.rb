#
# Cookbook Name:: oeinfra
# Recipe:: optsync
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
# include_recipe "oeinfra::settag"
environment = node.chef_environment.to_s.split("-").last

package "s3cmd" do
  action :install
end

oeinfra_settings = Chef::DataBagItem.load('oeinfra', 'settings')
oeinfra_secrets = Chef::EncryptedDataBagItem.load('oeinfra', 'secrets')

template "/root/.s3cfg" do
  action :create
  owner "root"
  mode "0600"
  source "optsync/s3cfg.erb"
  variables({
    :aws_access_key => oeinfra_settings["aws"]["#{environment}"]["aws_readonly_key"],
    :aws_secret_key => oeinfra_secrets["aws"]["#{environment}"]["aws_readonly_secret"]
  })
end

cookbook_file "/etc/cron.daily/sync_opt.sh" do
  owner "root"
  group "root"
  mode "0755"
  source "optsync/sync_opt.sh"
end
