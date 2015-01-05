#
# Cookbook Name:: pp2-store2
# Recipe:: Monit
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
oeinfra_settings = Chef::DataBagItem.load("oeinfra", "settings")
oeinfra_secrets  = Chef::EncryptedDataBagItem.load("oeinfra", "secrets")

node_name_tag = node.name.downcase.gsub(/_/, '-')

node.default[:monit][:mail_format][:from]    = node[:monit][:notify_email]
node.default[:monit][:poll_period]           = 120
node.default[:monit][:poll_start_delay]      = 240
node.default[:monit][:mail_format][:subject] = "$EVENT $SERVICE on #{node.chef_environment} check system #{node_name_tag} $DATE"
node.default[:monit][:mail_format][:message] = <<-EOS
Alert from check system #{node_name_tag}
Date: $DATE
For $SERVICE ($EVENT) and take $ACTION
---------------------------------------
$DESCRIPTION

EOS

node.default[:monit][:mailserver][:host]     = oeinfra_settings['aws_ses'][node.chef_environment.to_s.split("-").last]['host']
node.default[:monit][:mailserver][:port]     = oeinfra_settings['aws_ses'][node.chef_environment.to_s.split("-").last]['port']
node.default[:monit][:mailserver][:username] = oeinfra_settings['aws_ses'][node.chef_environment.to_s.split("-").last]['ses_access_key_id']
node.default[:monit][:mailserver][:password] = oeinfra_secrets['aws_ses'][node.chef_environment.to_s.split("-").last]['ses_secret_access_key']

include_recipe "monit::default"

template "/etc/monit/monitrc" do
  owner "root"
  group "root"
  mode 0700
  source 'monitrc.erb'
  notifies :restart, resources(:service => "monit"), :delayed
end

%w(tomcat7 apache2).each do |svc|
  cookbook_file "/etc/monit/conf.d/#{svc}.conf" do
    action :create
    owner "root"
    group "root"
    mode "0644"
    source "monit_#{svc}"
    notifies :restart, resources(:service => "monit"), :delayed
  end
end
