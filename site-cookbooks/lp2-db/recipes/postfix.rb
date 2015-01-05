# need to set answers to interactive debconf dialogs
package 'debconf-utils'

execute 'preseed-postfix' do
  command   'debconf-set-selections /var/cache/local/preseeding/postfix.seed'
  action    :nothing
  notifies  :install, 'package[postfix]', :immediately
end

lp2_settings = Chef::DataBagItem.load('lp2', 'settings')
lp2_secrets  = Chef::EncryptedDataBagItem.load('lp2', 'secrets')

node.set['lp2']['db']['postfix']['relay_host'] = lp2_settings[node.chef_environment.to_s]['db']['ses_endpoint']
node.set['lp2']['db']['postfix']['ses_access_key_id'] = lp2_settings[node.chef_environment.to_s]['db']['ses_access_key_id']
node.set['lp2']['db']['postfix']['ses_secret_access_key'] = lp2_secrets[node.chef_environment.to_s]['db']['ses_secret_access_key']

template '/var/cache/local/preseeding/postfix.seed' do
  source    'postfix/postfix.preseed.erb'
  owner     'root'
  group     'root'
  mode      0600
  notifies  :run, 'execute[preseed-postfix]', :immediately
end

# just setup a dummy server to relay mails to somewhere else
package 'postfix' do
  action  :nothing
end

package 'mailutils'

file '/etc/mailname' do
  owner    'root'
  group    'root'
  mode     0644
  content  'openenglish.com'
end

# install missing config and run postmap
cookbook_file "#{Chef::Config[:file_cache_path]}/postfix.ses.settings" do
  source  'postfix/postfix.ses.settings'
end

execute 'append-amazon-ses-config-to-postfix' do
  not_if   'grep "smtp_tls_security_level = encrypt" /etc/postfix/main.cf'
  user     'root'
  group    'root'
  command  "cat #{Chef::Config[:file_cache_path]}/postfix.ses.settings >> /etc/postfix/main.cf"
end

template '/etc/postfix/sasl_passwd' do
  user      'root'
  group     'root'
  mode      '0600'
  source    'postfix/sasl_passwd.erb'
  notifies  :run, 'execute[setup-postfix-sasl]', :immediately
end

execute 'setup-postfix-sasl' do
  user      'root'
  group     'root'
  command   'postmap /etc/postfix/sasl_passwd'
  notifies  :restart, 'service[postfix]', :immediately
  action    :nothing
end

service 'postfix' do
  action    :nothing
  supports  :restart => true, :reload => true, :start => true, :stop => true
end
