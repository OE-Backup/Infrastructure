#
# Cookbook Name:: oeinfra
# Attributes:: oeinfra
#
# Copyright 2013, Open English
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_attribute 'oeinfra::essential-packages'
default['oe-infra']['auth']['ldap_url'] = "ldaps://opendj1.oe-sys.com:1636"
default['oeinfra']['cron-node']['backup_scripts_path']  = "/opt/backup-scripts"
default['oeinfra']['cron-node']['public_cname']  = "cron-i.oe-sys.com"
default['accessgrp'] = ""
default['oeinfra']['prd']['nfs'] = "prd-infra-nfs-master.oe-sys.com"
%w(stg uat).each do |e|
  default['oeinfra'][e]['nfs'] = "stg-infra-nfs-master.thinkglish.com"
end
%w(qa1 qa2 qa qas qar dev).each do |e|
  default['oeinfra'][e]['nfs'] = "qa-infra-nfs-master.thinkglish.com"
end
%w(prd stg).each do |e|
default['oeinfra'][e]['sudoers'] = "80-sudoers-ldap-prd"
end
%w(qa1 qa2 qa qas qar dev).each do |e|
default['oeinfra'][e]['sudoers'] = "80-sudoers-ldap-dev"
end

# This are the default groups that are granted access through pam_access
default['oeinfra']['access_groups'] = [ 'ubuntu', 'infra', 'dba' ]

