#
# Cookbook Name:: infra-bastion
# Recipe:: default
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#

include_recipe 'oeinfra::apt'
include_recipe 'java'

# Install distro packages
node['packages']['distro'].each { |p|

  package p do
    action :install
  end

} unless node['packages']['distro'].nil?

# Install gems
node['packages']['gems'].each { |g|

  gem_package g do
    action :install
  end

} unless node['packages']['gems'].nil?


