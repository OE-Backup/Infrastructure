#
# Cookbook Name:: lp2-amq
# Recipe:: amq
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user "activemq" do
  shell "/bin/bash"
  system true
  action :create
end

if not File.exists?("/opt/apache-activemq-5.8.0")
  remote_file "/opt/apache-activemq-5.8.0-bin.tar.gz" do
    owner "root"
    group "root"
    mode "0644"
    source node["amq"]["url"]
    checksum node["amq"]["checksum"]
    notifies :run, "bash[install_amq]", :immediately
  end

  bash "install_amq" do
    user "root"
    group "root"
    cwd "/opt"
    code <<-EOH
    tar -zxf apache-activemq-#{node["amq"]["version"]}-bin.tar.gz;
    chown -R activemq apache-activemq-#{node["amq"]["version"]}
    EOH
    action :nothing
  end

end

link "/opt/activemq" do
  to "/opt/apache-activemq-#{node["amq"]["version"]}"
end

link "/etc/init.d/activemq" do
  to "/opt/activemq/bin/activemq"
end

lp2_settings = Chef::DataBagItem.load("lp2", "settings")
lp2_secrets = Chef::EncryptedDataBagItem.load("lp2", "secrets")

template "/etc/default/activemq" do
  user "root"
  group "nogroup"
  mode "0600"
  variables ({
    :jmxuser => lp2_settings[node.chef_environment.to_s]["amq"]["jmx_user"],
    :jmxpass => lp2_secrets[node.chef_environment.to_s]["amq"]["jmx_pass"]
  })
end

%w{ access password }.each do | ext |
template "/opt/activemq/conf/jmx.#{ext}" do
  user "activemq"
  group "activemq"
  mode "0600"
  variables ({
    :jmxuser => lp2_settings[node.chef_environment.to_s]["amq"]["jmx_user"],
    :jmxpass => lp2_secrets[node.chef_environment.to_s]["amq"]["jmx_pass"]
  })
end
end

remote_file "/opt/activemq/postgresql-9.2-1002-jdbc4.jar" do
    action :create_if_missing
    owner "activemq"
    group "activemq"
    mode 0644
    source "#{node["amq"]["jars_url"]}/postgresql-9.2-1002-jdbc4.jar"
end

template "/opt/activemq/conf/activemq.xml" do
  user "activemq"
  group "activemq"
  mode "0600"
  variables ({
    :jdbc_user => lp2_settings[node.chef_environment.to_s]["amq"]["jdbc_user"],
    :jdbc_pass => lp2_secrets[node.chef_environment.to_s]["amq"]["jdbc_pass"],
    :jdbc_host => lp2_settings[node.chef_environment.to_s]["amq"]["jdbc_host"],
    :jdbc_db => lp2_settings[node.chef_environment.to_s]["amq"]["jdbc_db"],
    :jdbc_port => lp2_settings[node.chef_environment.to_s]["amq"]["jdbc_port"],
    :jdbc_datasource => lp2_settings[node.chef_environment.to_s]["amq"]["jdbc_datasource"],
    :jdbc_initialConnections => lp2_settings[node.chef_environment.to_s]["amq"]["jdbc_initialConnections"],
    :jdbc_maxConnections => lp2_settings[node.chef_environment.to_s]["amq"]["jdbc_maxConnections"]

  })
end
