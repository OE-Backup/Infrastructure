## Set it as false if you don't want to run this be run.
#  By default it is run it, since it is defined here.

default['monitoring']['datadog']['enabled'] = true

default['datadog']['databag'] = 'third-party'
default['datadog']['databag_item'] = 'datadog'

default['datadog']['url'] = 'http://dtdg.co/agent-install-ubuntu'