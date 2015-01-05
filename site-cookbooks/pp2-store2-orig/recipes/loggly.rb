#
# Cookbook Name:: pp2-store2
# Recipe:: Loggly
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
# drop logging privileges to the correct group
bash "set-rsyslog-correct-privileges" do
  not_if "grep '^\$PrivDropToGroup adm$' rsyslog.conf"
  user "root"
  code <<-EOT
    sed -e 's/\$PrivDropToGroup syslog$/$PrivDropToGroup adm/' -i /etc/rsyslog.conf
  EOT
  notifies :restart, "service[rsyslog]", :immediately
end

oeinfra_secrets  = Chef::EncryptedDataBagItem.load("oeinfra", "secrets")
customer_token = oeinfra_secrets["loggly"][node.chef_environment.to_s.split("-").last]["customer_token"]

template "/etc/rsyslog.d/60-tomcat.conf" do
  owner "root"
  group "root"
  mode "0644"
  variables({
    :customer_token => customer_token,
    :logging_tag => node.name.downcase.gsub(/_/, '-'),
    :env => node.chef_environment.to_s
  })
  notifies :restart, "service[rsyslog]", :immediately
end

service "rsyslog" do
  action :nothing
  supports :restart => true
end
