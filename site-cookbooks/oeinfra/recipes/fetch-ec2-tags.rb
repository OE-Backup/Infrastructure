# Cookbook Name:: oeinfra
# Recipe:: aws-ec2-tags
#
# Copyright 2014, Open English
#
# All rights reserved - Do Not Redistribute
#

# needed due to a fog dependency on nokogiri
# nokogiri is a native library so it needs
# to be compiled during chef compile phase...
include_recipe "build-essential"

# set 'ec2' hint explicitly so ohai can populate
# automatic attributes with ec2 instance meta-data
directory "/etc/chef/ohai/hints" do
  recursive true
end

file "/etc/chef/ohai/hints/ec2.json" do
  action :touch
  notifies :reload, "ohai[ec2]", :immediately
  subscribes :create, "directory[/etc/chef/ohai/hints]", :immediately
end

ohai "ec2" do
  action :nothing
  plugin "ec2"
end

# fog emits a warning if unf is not installed
chef_gem 'unf'
chef_gem 'fog'

require 'fog'

# there is not an attribute for EC2 region zone name so
# this is fetched from availability zone attribute
ruby_block 'set-ec2-region-attribute' do
  block do
    node.set['ec2']['region'] = node['ec2']['placement_availability_zone'].chop
  end
  action :create
end

# put EC2 instance tags in an attribute named node['ec2']['tags']
ruby_block 'fetch-ec2-instance-tags' do
  block do
    ec2_connection = Fog::Compute::AWS.new({:use_iam_profile => true, :region => node.set['ec2']['region']})
    instance_tags = ec2_connection.describe_tags({'resource-id' => node['ec2']['instance_id']})
    node.set['ec2']['tags'] = {}
    instance_tags.data[:body]['tagSet'].each { |t| node.set['ec2']['tags'][t['key'].to_s] = t['value'] }
  end
  action :create
end

# based on EC2 instance tags I set relevant Chef node tags
ruby_block 'set-chef-node-tags' do
  block do
    node.tag('sandbox')  if     node['ec2']['tags']['Sandbox']
    node.tag('official') unless node['ec2']['tags']['Sandbox']
  end
  action :create
end
