#
# Cookbook Name:: lp2-db
# Recipe:: dba
#
# Copyright 2013, Open English
#
# All rights reserved - Do Not Redistribute

node.set['lp2']['db']['dba'] = {
  "Cecilia Barbalarga" => "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIBqgQ+Wx37JBVngbyfKSR2hdu0Pw9SVGOfRynUPKpHOrnWeVt1PgZGB2mv8WQCe9LEqxIDaMaZk34BPWg4b3SeZqQ6T7361THqp4b2wkpk0Q6eJluo7Td7Lq+Ek4YYcvLL7JVewj+TxashQ1fLGbApyWKy5aRxxWEuLuzmI1SfGiQ== rsa-key-20130520",
  "Jorge Fernandez" => "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIBgMv1YVSsem8cC+i1WT2b4YpkwG6hjoJWzxFg7buqQXe6bHeYWB8IMQw5aTRd9HlJf88oysBLNlmu33HHsde9vcjbTqGa1Gewklz/fgqhRrQ1pCSU77QPKDRT5EmQZ4G72M9dZ+0FkvHPdw8q8c1MK6bt3B12lMuas3ICERNbHaw== rsa-key-20121101"
}

authorized_keys_path = '/home/ubuntu/.ssh/authorized_keys'

node['lp2']['db']['dba'].keys.each do |dba|
  execute "add-dba-ssh-pubkey" do
    not_if   "grep '#{dba}' #{authorized_keys_path}"
    user     'ubuntu'
    group    'ubuntu'
    command  "(echo '\##{dba}' && echo '#{node['lp2']['db']['dba'][dba]}') >> #{authorized_keys_path}"
  end
end

cookbook_file "#{node['lp2']['db']['postgresql']['homedir']}/README_dba.txt" do
  owner   'postgres'
  group   'postgres'
  mode    0644
  source  'dba/README_dba.txt'
end
