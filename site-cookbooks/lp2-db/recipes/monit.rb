#
# Cookbook Name:: lp2-db
# Recipe:: monit
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
lp2_settings = Chef::DataBagItem.load('lp2', 'settings')
lp2_secrets  = Chef::EncryptedDataBagItem.load('lp2', 'secrets')

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

node.default[:monit][:mailserver][:host]     = 'email-smtp.us-east-1.amazonaws.com'
node.default[:monit][:mailserver][:port]     = 587
node.default[:monit][:mailserver][:username] = lp2_settings[node.chef_environment]['aws']['ses_access_key_id']
node.default[:monit][:mailserver][:password] =  lp2_secrets[node.chef_environment]['aws']['ses_secret_access_key']

include_recipe "monit::default"

template '/etc/monit/monitrc' do
  owner    'root'
  group    'root'
  mode     0700
  source   'monit/monitrc.erb'
  notifies :restart, resources(:service => 'monit'), :delayed
end

%w(postgresql).each do |svc|
  cookbook_file "/etc/monit/conf.d/#{svc}.conf" do
    action    :create
    owner     'root'
    group     'root'
    mode      0644
    source    "monit/monit_#{svc}"
    notifies  :restart, resources(:service => 'monit'), :delayed
  end
end
