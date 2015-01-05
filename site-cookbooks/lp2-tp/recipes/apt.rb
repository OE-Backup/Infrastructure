#
# Cookbook Name:: lp2-tp
# Recipe:: apt
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt::default"

# add internal openenglish repository
apt_repository 'openenglish' do
  uri          'http://apt.oe-sys.com/'
  distribution 'precise/'
  key          'http://apt.oe-sys.com/15C962ECB4F30082.pub'
end
