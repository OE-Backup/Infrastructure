#
# Cookbook Name:: oeinfra
# Recipe:: apt
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apt::default"

# Internal OpenEnglish repository
apt_repository 'openenglish_repository' do
  uri          'http://apt.oe-sys.com/'
  distribution "#{node['lsb']['codename']}/"
  key          'http://apt.oe-sys.com/15C962ECB4F30082.pub'
end


# Internal OpenEnglish mirror
apt_repository 'openenglish_mirror' do
  uri          'http://ubuntu-repo.oe-sys.com/archive/ubuntu/'
  distribution "#{node['lsb']['codename']}"
  components ["main","universe"]
end

# FIXME: this is breaking tomcat7 installation
#cookbook_file "etc_apt_preferences" do
#  source "apt/preferences"
#  path "/etc/apt/preferences"
#  owner "root"
#  group "root"
#  mode "0644"
#  action :delete
#end

