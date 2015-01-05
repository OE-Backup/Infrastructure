#
# Cookbook Name:: oeinfra
# Recipe:: swap
#
# Copyright 2013, Openenglish
#
# All rights reserved - Do Not Redistribute
#
directory "/opt/swap" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

cookbook_file "swap.sh" do
    source "swap.sh"
    path "/opt/swap/swap.sh"
    mode "0755"
    action :create
end

bash "adding_to_rc.local" do
  not_if "swapon --summary | grep -- /mnt/swapfile"
  user "root"
  cwd "/tmp"
  code <<-EOH
    sed -i '/exit/i\/opt/swap/swap.sh' /etc/rc.local
    chmod +x /etc/rc.local
    sh /opt/swap/swap.sh
  EOH
end
