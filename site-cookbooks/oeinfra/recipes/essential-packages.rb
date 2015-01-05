#
# Cookbook Name:: oeinfra
# Recipe:: essential-packages
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#


# Default packages
node['oeinfra']['essential-packages'].each do |p| 
  package p[:name] do
    action  :install
    version p[:version]
  end
end unless node['oeinfra']['essential-packages'].nil?

# Packages from environments
node[node.chef_environment.to_s]['oeinfra']['essential-packages'].each do |p| 
  package p[:name] do
    action  :install
    version p[:version]
  end
end unless node[node.chef_environment.to_s]['oeinfra']['essential-packages'].nil?

