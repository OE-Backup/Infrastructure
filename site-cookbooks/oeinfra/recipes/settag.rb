#
# Cookbook Name:: oeinfra
# Recipe:: settag
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
#
include_recipe "aws-fixes::r53-install"

ambiente = node.chef_environment.to_s.split("-").last
log ambiente

case ambiente
  when "prd"
  $ambColor="1;31m"
  domain="oe-sys.com"
  when "stg","uat"
  $ambColor="1;33m"
  domain="thinkglish.com"
  when "dev","qa","qas","qar", "qa1", "qa2"
  $ambColor="32;1m"
  domain="thinkglish.com"
end

aws_settings = Chef::DataBagItem.load("oeinfra", "settings")
aws_secrets = Chef::EncryptedDataBagItem.load("oeinfra", "secrets")

ENV['ambColor'] = $ambColor
ENV['EC2_ACCESS_KEY'] = aws_settings["aws"]["#{ambiente}"]["aws_readonly_key"]
ENV['EC2_SECRET_KEY'] = aws_secrets["aws"]["#{ambiente}"]["aws_readonly_secret"]

template "/etc/profile.d/settag.sh" do
  source "settag/settag.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  action :create
  variables ({
    :apphost => node.name.downcase,
    :ambColor => $ambColor
  })
end

# Set default /etc/bash.bashrc to overwrite old PS1 setting ;)
cookbook_file "/etc/bash.bashrc" do
  source "settag/bash.bashrc"
  owner "root"
  group "root"
  mode 0644
end

# Set PS1 for future users
template "/etc/skel/.bashrc" do
  source "settag/bashrc-user"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :usercolor => "37;1m",
  )
  action :create
end

# Set PS1 for ubuntu user
# Miguel to-do: fix this
# User ubuntu it's not guaranteed to exists in every server...
template "/home/ubuntu/.bashrc" do
  only_if 'grep "^ubuntu:" /etc/passwd'
  source "settag/bashrc-user"
  owner "ubuntu"
  group "ubuntu"
  mode "0644"
  variables(
    :usercolor => "37;1m",
  )
  action :create
end


# Same prompt, red color for user root
template "/root/.bashrc" do
  source "settag/bashrc-root"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :usercolor => "31m",
  )
  action :create
end

ohai "reload" do
  action :reload
end

# Create/replace route53 record
ENV['AWS_ACCESS_KEY_ID'] = aws_settings["aws"]["aws_cli53_key"]
ENV['AWS_SECRET_ACCESS_KEY'] = aws_secrets["aws"]["aws_cli53_secret"]
