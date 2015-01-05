## Set it as false if you don't want to run this be run.
#  By default it is run it, since it is defined here.

default['monitoring']['appdynamics']['enabled'] = true
#

default['appdynamics']['databag'] = 'third-party'
default['appdynamics']['databag_item'] = 'appdynamics'

default['appdynamics']['service'] = ''

default['filerepo_host'] = 'https://s3.amazonaws.com/'
default['appdynamics']['base'] = '/opt/appDynamics'
default['appdynamics']['user'] = 'root'
default['appdynamics']['group'] = 'root'


default['appdynamics']['agent']['checksum']      = "15bcc17b80a24e2e3b786a15ae9fea3db600482cc46b5dfc75ab6229588e7a1b"
default['appdynamics']['agent']['install_dir']   = "/opt/appDynamics/AppServerAgent"
default['appdynamics']['agent']['user']  = "root"
default['appdynamics']['agent']['group'] = "root"

default['appdynamics']['machine']['checksum']      = "931ae540654c061438a11ad5dba69748f90a75cf65d9ce8eb2733a8251fb244c"
default['appdynamics']['machine']['install_dir']   = "/opt/appDynamics/MachineAgent"
default['appdynamics']['machine']['user']  = "root"
default['appdynamics']['machine']['group'] = "root"

default['appdynamics']['java_options'] = ""