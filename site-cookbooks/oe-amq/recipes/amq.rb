#
# Cookbook Name:: oe-amq
# Recipe:: amq
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"

user "activemq" do
  shell "/bin/bash"
  system true
  action :create
end

if not File.exists?("/opt/apache-activemq-5.6.0")
  remote_file "/opt/apache-activemq-5.6.0-bin.tar.gz" do
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
    tar xzvf apache-activemq-#{node["amq"]["version"]}-bin.tar.gz;
    chown -R activemq apache-activemq-#{node["amq"]["version"]}
    EOH
    action :nothing
  end

end

link "/opt/activemq" do
  to "/opt/apache-activemq-#{node["amq"]["version"]}"
end

remote_file "/opt/activemq/lib/postgresql-9.2-1002-jdbc4.jar" do
    action :create_if_missing
    owner "activemq"
    group "activemq"
    mode 0644
    source "#{node["amq"]["jars_url"]}/postgresql-9.2-1002-jdbc4.jar"
end

# Generates files: jmx.password and jmx.access
%w{ access password }.each do | ext |
template "/opt/activemq/conf/jmx.#{ext}" do
  user "activemq"
  group "activemq"
  mode "0600"
  notifies :restart,'service[activemq]', :delayed
end
end

template "/etc/default/activemq" do
  source "default_activemq.erb"
  user "root"
  group "nogroup"
  mode "0600"
end

template "/opt/activemq/bin/activemq" do
  source "init_5.6_activemq.erb"
  user "root"
  group "root"
  mode "0755"
end

link "/etc/init.d/activemq" do
  to "/opt/activemq/bin/activemq"
  notifies :restart,'service[activemq]', :delayed
end

template "/opt/activemq/conf/activemq.xml" do
  source "activemq-5.6.xml.erb"
  user "activemq"
  group "activemq"
  mode "0644"
end


link "/etc/init.d/activemq" do
  to "/opt/activemq/bin/activemq"
  notifies :restart,'service[activemq]', :delayed
end


service "activemq" do
  supports :status => true, :restart => true, :stop => false, :start => true
  action :nothing
end

