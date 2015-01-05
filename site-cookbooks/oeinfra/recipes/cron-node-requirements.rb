# need to set answers to interactive debconf dialogs
package 'debconf-utils'

execute 'preseed-postfix' do
  command   'debconf-set-selections /var/cache/local/preseeding/postfix.seed'
  action    :nothing
  notifies  :install, 'package[postfix]', :immediately
end

oeinfra_settings = Chef::DataBagItem.load('oeinfra', 'settings')
oeinfra_secrets  = Chef::EncryptedDataBagItem.load('oeinfra', 'secrets')

template '/var/cache/local/preseeding/postfix.seed' do
  source      'cron-node/postfix.preseed.erb'
  owner       'root'
  group       'root'
  mode        '0600'
  notifies    :run, 'execute[preseed-postfix]', :immediately
  variables({
    :public_cname => node['oeinfra']['cron-node']['public_cname'],
    :relay_host   => oeinfra_settings['cron-node']['aws']['ses']['endpoint']
  })
end

# needed for manage_scripts.py
package 'python' 
package 'python-boto'
package 'mailutils'

# just setup a dummy server to relay mails to somewhere else
package 'postfix' do
  action :nothing
end

# install missing config and run postmap
cookbook_file "#{Chef::Config[:file_cache_path]}/postfix.ses.settings" do
  source 'cron-node/postfix.ses.settings'
end

execute 'append-amazon-ses-config-to-postfix' do
  not_if  'grep "smtp_tls_security_level = encrypt" /etc/postfix/main.cf'
  user    'root'
  group   'root'
  command "cat #{Chef::Config[:file_cache_path]}/postfix.ses.settings >> /etc/postfix/main.cf"
end

template '/etc/postfix/sasl_passwd' do
  user              'root'
  group             'root'
  mode              '0600'
  source            'cron-node/sasl_passwd.erb'
  variables({
    :aws_access_key => oeinfra_settings['cron-node']['aws']['ses']['access_key_id'],
    :aws_secret_key =>  oeinfra_secrets['cron-node']['aws']['ses']['secret_access_key']
  })
  notifies          :run, 'execute[setup-postfix-sasl]', :immediately
end

execute 'setup-postfix-sasl' do
  user      'root'
  group     'root'
  command   'postmap /etc/postfix/sasl_passwd'
  notifies  :restart, 'service[postfix]', :immediately
  action    :nothing
end

service 'postfix' do
  action   :nothing
  supports :restart => true, :reload => true, :start => true, :stop => true
end
