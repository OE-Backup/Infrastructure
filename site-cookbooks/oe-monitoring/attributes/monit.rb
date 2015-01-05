## Set it as false if you don't want to run this be run.
#  By default it is run it, since it is defined here.

default['monitoring']['monit']['enabled'] == true
default['monitoring']['monit']['mail_from'] = "someone@openenglish.com"
default['monitoring']['monit']['mail_to'] = "someone@openenglish.com"

default['monit']['databag'] =  "oeinfra"
default['monit']['databag_item'] = "secrets"

default['monit']['subject'] = "Subject"
default['monit']['message'] = "Some message"

default['monit']['server'] = "email-smtp.us-east-1.amazonaws.com"
default['monit']['port'] = "587"
default['monit']['username'] = ""
default['monit']['password'] = ""

default['monit']['poll_period'] = "60"
default['monit']['poll_start_delay'] = "120"

default['monit']['log_file'] = "/var/log/monit.log"
