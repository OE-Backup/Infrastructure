oe-logs Cookbook
================

This cookbook implements a series of recipes related to logging:

  * log: Create / Link directory where the service logs are going to be held
  * logrotate: Generate a logrotate file for the service
  * Make a wish

Usage
-----

This cookbook is intended to be called from another service's cookbook, i.e.:

```chef
# 
# Cookbook Name:: oe-tomcat
# Recipe:: log
#
# Description:
#   TODO
#
# Parameters:
#   TODO
#

include_recipe 'oe-logs::log'
include_recipe 'oe-logs::logrotate'

```

Attributes
----------

#### Default attributes

Defined in @attributes/default.rb@

  * default['oe-logs']['logrotate']['prefix'] (@/etc/logrotate.d@)

#### Required attributes

The required attributes should be set in the calling cookbook's attribute file
(i.e. @some_service::log@)

```ruby
default['oe-logs']['services']['some_service'] = {
  
  'logrotate' => {
    'logfile'      => '/var/log/some_service/service.log',
    'interval'     => 'daily',
    'rotate_count' => '90',
    'owner'        => 'user1',
    'group'        => 'group1',
  },

  'log'       => {
    'prefix'  => '/mnt/log/some_service',
    'symlink' => '/var/log/some_service',
    'owner'   => 'user1',
    'group'   => 'group1',
  }

}
```

oe-logs::logrotate
------------------

The logrotate facility will render the following template:

```
## [ Chef generated file ] ##

<%= @cfg['logfile'] %> {
  copytruncate
  compress
  missingok
  <%= @cfg['interval'] %>
  rotate <%= @cfg['rotate_count'] %>
  create 644 <%= @cfg['owner']%> <%= @cfg['group']%>
}
```

### ['logrotate']['logfile']

The file to be rotated

### ['logrotate']['interval']

The interval on wich the logs are rotated. Posible values are (the same as logrotate)

  * hourly
  * daily
  * weekly
  * monthly
  * yearly

### ['logrotate']['rotate_count']

Log retention. After this many rotations, logs will start to get purged.

### ['logrotate']['owner'] / ['logrotate']['group']

The user and group owning the rotated file. The original file won't have its attributes
changed, as the templates does a @copytruncate@.

oe-logs::log
------------

This recipe will setup the service's log directory.

If a symlink should be created (@not ...['log']['symlink'].nil?@), any existing logs will
be moved to the destination directory, and the symlink will then be created.

### ['log']['prefix']

The actual directory or the logs.

### ['log']['symlink']

Symlink to be created (optional)

### ['log']['owner'] / ['log']['group']

The user and group for the logs directory

Contributing
------------

Hack it &  send a PR 

License and Authors
-------------------

Authors:
  * Emiliano Castagnari
