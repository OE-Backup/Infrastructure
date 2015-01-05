#
# Cookbook Name:: website2-dotcms
# Recipe:: dotcms
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#

environment = node.chef_environment.to_s.split("-").last

package "authbind" do
  action :install
end

group 'dotcms' do
  action  :create
  gid     1001  
end

user "dotcms" do
  shell     "/bin/bash"
  supports  :manage_home => true
  uid 1001
  gid 1001
  action :create
end

directory "/opt/dotcms" do
  owner "dotcms"
  group "dotcms"
  mode "0755"
  action :create
end

if not File.exists?("/opt/dotcms/dotserver")
  remote_file "/opt/dotcms/dotcms_#{node["dotcms"]["version"]}.tar.gz" do
    owner "dotcms"
    group "dotcms"
    mode "0644"
    source "https://s3.amazonaws.com/infra-packages/dotcms/dotcms_#{node["dotcms"]["version"]}.tar.gz"
    checksum node["dotcms"]["checksum"]
    notifies :run, "bash[install_dotcms]", :immediately
  end

  bash "install_dotcms" do
    user "dotcms"
    group "dotcms"
    cwd "/opt/dotcms"
    code <<-EOH
    tar -zxf dotcms_#{node["dotcms"]["version"]}.tar.gz
    EOH
    action :nothing
  end

end

if not File.exists?("#{node["dotcms"]["jmx_jar_fs_path"]}/#{node["dotcms"]["jmx_jar_file"]}")
  remote_file "#{node["dotcms"]["jmx_jar_fs_path"]}/#{node["dotcms"]["jmx_jar_file"]}" do
    owner "dotcms"
    group "dotcms"
    mode "0644"
    source "#{node["dotcms"]["tomcat_libs_bucket_path"]}/#{node["dotcms"]["jmx_jar_file"]}"
  end
end

# Fixing execution permissions not given in tar.gz file
%w{ bin tomcat/bin }.each do |dir|
  execute "fixPerm" do
    cwd "/opt/dotcms/dotserver"
    user "root"
    group "root"
    command "find #{dir} -name '*.sh' -exec chmod 755 {} \\;"
  end
end

# Authbind configuration
node['etc']['passwd'].each do |user, data|
  if user.to_s == "dotcms"
    cookbook_file "/etc/authbind/byuid/#{data["uid"]}" do
      source "authbind_#{user}"
      owner user
      group data['gid']
      mode 0500
    end
  end
end

template '/opt/dotcms/dotserver/bin/startup.sh' do
  action  :create
  source  'startup.sh.erb'
  owner   'dotcms'
  group   'dotcms'
  mode    0755
end

website2_settings = Chef::DataBagItem.load("website2", "settings").to_hash()[node.chef_environment]
website2_secrets = Chef::EncryptedDataBagItem.load("website2", "secrets").to_hash()[node.chef_environment]

#DB Configuration
template "/opt/dotcms/dotserver/tomcat/conf/Catalina/localhost/ROOT.xml" do
  source "ROOT.xml.erb"
  owner "dotcms"
  group "dotcms"
  mode "0644"
  variables({
    :jdbc_user => website2_settings["tomcat"]["jdbc_user"],
    :jdbc_pass => website2_secrets["tomcat"]["jdbc_pass"],
    :jdbc_url => website2_settings["tomcat"]["jdbc_url"],
    :jdbc_maxactive => website2_settings["tomcat"]["jdbc_maxActive"],
    :jdbc_maxidle => website2_settings["tomcat"]["jdbc_maxIdle"],
  })
end

template "/opt/dotcms/dotserver/tomcat/conf/server.xml" do
  action :create
  source 'server.xml.erb'
  owner "dotcms"
  group "dotcms"
  mode "0644"
  variables ({
    :keystore_pass => website2_secrets["tomcat"]["keystorepass"]
  })
end

template "/opt/dotcms/dotserver/tomcat/conf/tomcat-users.xml" do
  action :create
  source 'tomcat-users.xml.erb'
  owner "dotcms"
  group "dotcms"
  mode "0644"
  variables ({
    :admin_pass => website2_secrets["tomcat"]["admin_pass"],
    :oeprobe_pass => website2_secrets["tomcat"]["oeprobe_pass"]
  })
end

# SSL configuration
# FIXME: move to environment 
case node.chef_environment.to_s.split("-").last
  when "stg","dev"
    directory "/opt/dotcms/private" do
      owner "dotcms"
      group "dotcms"
      mode "0744"
      action :create
    end

    remote_file "/opt/dotcms/private/thinkglish.com.pkcs12" do
      owner "root"
      group "dotcms"
      mode "0640"
      source "https://s3.amazonaws.com/infra-packages/dotcms/certs/#{environment}/star_thinkglish_com.pkcs12"
    end

    cookbook_file "/opt/dotcms/dotserver/tomcat/conf/web.xml" do
      owner "dotcms"
      group "dotcms"
      mode "0644"
      action :create
    end
end

# env_variables configuration

if not File.exists?("/opt/env_variables")
  directory "/opt/env_variables" do
    owner "root"
    group "dotcms"
    mode "0750"
    action :create
  end
end

template "/opt/env_variables/salesforce.properties" do
  owner "root"
  group "dotcms"
  mode "0640"
  variables ({
    :user => website2_settings["salesforce"]["user"],
    :pass => website2_secrets["salesforce"]["pass"],
    :environment => website2_settings["salesforce"]["environment"],
    :timeout => website2_settings["salesforce"]["timeout"],
    :ownerfinance => website2_settings["salesforce"]["ownerfinance"],
    :isproduction => website2_settings["salesforce"]["isproduction"],
    :endpointaddress => website2_secrets["salesforce"]["endpointaddress"],
    :origin => website2_settings["plugins"]["origin"],
    :sf_client_id => website2_settings["salesforce2"]["sf_client_id"],
    :sf_client_secret => website2_secrets["salesforce2"]["sf_client_secret"],
    :sf_user => website2_settings["salesforce2"]["sf_user"],
    :sf_pass => website2_secrets["salesforce2"]["sf_pass"],
    :sf_uri => website2_settings["salesforce2"]["sf_uri"]
  })
end

cookbook_file "/etc/init.d/dotcms" do
  source "dotcms.initd"
  owner "root"
  group "root"
  mode 0755
end

if not File.exists?("/opt/dotcms/dotserver/dotCMS/assets")
  link "/opt/dotcms/dotserver/dotCMS/assets" do
    to "/srv/assets"
  end
end

# execute "dotCMS stop" do
#     cwd "/opt/dotcms/dotserver"
#     user "dotcms"
#     group "dotcms"
#     command "./bin/shutdown.sh"
# end
# 
# if File.exists?("/tmp/dotserver.pid")
#   file "/tmp/dotserver.pid" do
#     action :delete
#   end
# end
# 
# execute "dotCMS start" do
#     cwd "/opt/dotcms/dotserver"
#     user "dotcms"
#     group "dotcms"
#     command "./bin/startup.sh"
# end

#Log4j logger
template "/opt/dotcms/dotserver/tomcat/lib/log4j.xml" do
  owner "dotcms"
  group "dotcms"
  mode "0644"
end

template "/etc/security/limits.conf" do
  owner "root"
  group "root"
  mode 0644
  variables ({
    :openfiles => node["oeinfra"]["openfiles"]
  })
end

# OpenFiles reporting
cookbook_file "/opt/dotcms/lsofStats.sh" do
  owner "root"
  group "root"
  mode 0755
end

cookbook_file "/etc/cron.d/of" do
  source "of.cron"
  owner "root"
  group "root"
  mode 0644
end

#Probe installation
remote_file "/opt/dotcms/dotserver/tomcat/webapps/oe-probe.war" do
  action :create_if_missing
  owner "dotcms"
  group "dotcms"
  mode "0644"
  source "#{node['website2']['oe-probe_url']}"
  checksum "#{node['website2']['oe-probe_checksum']}"
end

