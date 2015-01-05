#
# Cookbook Name:: oeinfra
# Recipe:: dns
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute
#
#
include_recipe "aws-fixes::r53-install"

# to-do: this code has to be refactored
# it's here just for compatibility sake
ambiente = node.chef_environment.to_s.split("-").last
log ambiente

case ambiente
  when "prd"
  domain="oe-sys.com"
  when "stg","uat"
  domain="thinkglish.com"
  when "dev","qa","qas","qar"
  domain="thinkglish.com"
end

# Register instance name in Route53
execute "update route53" do
  user    'root'
  group   'root'
  command "cli53 rrcreate -x 600 #{domain} #{node.name.downcase} A #{node.ipaddress} --replace"
  # to-do: document why this can return these values
  returns [0,2]
end
