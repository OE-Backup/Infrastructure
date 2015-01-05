#
# Cookbook Name:: infra-nfs
# Recipe:: createhome
#
# Copyright 2013, OpenEnglish
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/opt/mkhome.sh" do
  owner "root"
  group "root"
  mode 0750
end

cookbook_file "/etc/cron.d/mkhome" do
  source "mkhome.cron"
  owner "root"
  group "root"
  mode 0750
end
