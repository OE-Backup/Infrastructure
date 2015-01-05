#
# Cookbook Name:: lp2-ui
# Attributes:: lp2
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

default['lp2']['maintenance_mode']  = false

default['ssl']['fqdn']  = 'openenglish.com'
default['ssl']['type']  = 'pem'
default['ssl']['owner'] = 'www-data'
default['ssl']['group'] = 'root'
default['ssl']['pem']['prefix'] = '/opt/lp2/ssl'

default['tomcat']['maxThreads'] = '400' 

# oe-tomcat::libs
default['tomcat']['jars'] = {
  :add => [
     { 
       :name   => 'asm-3.2.jar',
       :digest => '1ac3b6e18dbd7053cdbef7374b8401ad7ff64ceb80060ccace4dc35e6eb89d49' 
     },
     { 
       :name   => 'kryo-1.04.jar',
       :digest => '66db375e68c91d3938c91ede5bf3af370cdbcccbe81c9bf325c20845de855cd8'
     },
     {
       :name   => 'kryo-serializers-0.11.jar',
       :digest => '22252e3a6904917357adfaa5ed4394992c1e4e22f8dbdcf639ff9d29681d7ce7'
     },
     {
       :name   => 'memcached-session-manager-1.8.1.jar',
       :digest => 'f25810d52932e5cba14958b65a90a22cf874f610ddfa6ffcf1167fe4d71a150b'
     },
     {
       :name   => 'memcached-session-manager-tc7-1.8.1.jar',
       :digest => 'b8b540b0fad843622e22f85e8a51f4da1bd819775f51e84ca432975c9434000b' 
     },
     {
       :name   => 'minlog-1.2.jar',
       :digest => '4ac7ce56b1ec76852d072cea636758d71b91e8d58a0393b6ba43ea54740ef480' 
     },
     {
       :name   => 'msm-kryo-serializer-1.8.1.jar',
       :digest => '989a661c611ffb5d1261612a6e7394a8c7e695b929fe324a3069ebc6cb9803ab' 
     },
     {
       :name   => 'reflectasm-1.01.jar',
       :digest => '471aec8479fc610c996acc685a85e00e98f1d89e5ca14dc226327feb8daaa6ba' 
     },
     {
       :name   => 'spymemcached-2.10.2.jar',
       :digest => '57b8cb5a15ffa24b6a8ec1dc763f283fd2ce2be7552a9568ea7b9af50e2e1044' 
     },
     {
       :name   => 'postgresql-9.2-1002-jdbc4.jar',
       :digest => 'c8ae36c9014956baac6f3b1b6d9bbdf3e535bdabb6841fdb2c93e41ee105cee0'
      },
     {
      :name   => "catalina-jmx-remote.jar",
      :digest => "4973c02140b67e31550ddfc5fbdbd5c577888ee29153c8df0fa8430f46aade95"
     },
  ],

  :remove => [
    'memcached-session-manager-1.6.4.jar',
    'memcached-session-manager-tc7-1.6.4.jar',
    'spymemcached-2.8.12.jar'
  ]
}


