
default['monitoring']['loggly']['enabled'] = true
default['monitoring']['loggly']['prefix']  = '/etc/rsyslog.d'
default['monitoring']['loggly']['server']  = 'logs-01.loggly.com:514'

default['monitoring']['databag']      = 'third-party'
default['monitoring']['databag_item'] = 'loggly'
