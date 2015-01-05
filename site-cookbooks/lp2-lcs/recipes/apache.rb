#
# Cookbook Name:: lp2-lcs
# Recipe:: apache
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#

include_recipe "apache2::default"
include_recipe "apache2::mod_proxy_http"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_status"

if node['apache']['vhosts'].nil?
  Chef::Log.warn("node[apache][vhosts] is not defined")
  return
end

node['apache']['vhosts'].each { |vhost|
  
  template "#{node['apache']['dir']}/sites-available/#{vhost}" do
    owner     'root'
    group     'root'
    mode      '0644'
    source    vhost.split('-').last == 'ssl' ? 'vhost-ssl.erb' : 'vhost.erb'
  end
  
  apache_site vhost do
    enable true
    action :nothing
    subscribes :run, "template[#{node['apache']['dir']}/sites-available/#{vhost}]", :delayed
  end

}

