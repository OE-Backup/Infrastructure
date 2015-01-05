#
# Cookbook Name:: lp2-lcs
# Attributes:: lp2-lcs
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

default['lp2']['sfdcmetrics']['path']  = '/opt/SFDCMetrics'
default['lp2']['sfdcmetrics']['owner'] = 'ubuntu'
default['lp2']['sfdcmetrics']['group'] = 'ubuntu'
default['lp2']['sfdcmetrics']['logfile'] = '/var/log/SFDCMetrics.log'
