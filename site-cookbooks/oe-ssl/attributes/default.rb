
default['ssl']['databag']     = 'ssl'
default['ssl']['databag_enc'] = 'ssl-keys'

default['ssl']['owner'] = 'root'
default['ssl']['group'] = 'root'

default['ssl']['pem'] = {
  'prefix' => '/etc/open_english/ssl',
}

default['ssl']['keystore'] = {
  'prefix' => '/etc/open_english/ssl',
}

default['ssl']['pkcs12'] = {
  'prefix' => '/etc/open_english/ssl',
}
