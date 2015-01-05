#
# Cookbook Name:: oe-postgresql
# Recipe:: sysctl
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#

# Define sysctl parameters based on the node attribute
# node['postgresql']['sysctl']['attrs'], which is a hash
# containing each kernel parameter as a key, and its value

if node['postgresql']['sysctl'].nil? then
  Chef::Log.warn("#{cookbook_name}::#{recipe_name}: No sysctl attributes defined (node['postgresql']['sysctl'])")
  return
end

cnt = "# Chef managed file\n"
node['postgresql']['sysctl']['attrs'].map { |key,value| cnt <<= "#{key} = #{value}\n" }

file node['postgresql']['sysctl']['cfg'] do
  action    :create
  owner     'root'
  group     'root'
  mode      0644
  content   cnt
  notifies  :run, 'execute[postgresql-sysctl]', :immediately
end

execute 'postgresql-sysctl' do
  command "/sbin/sysctl -p #{node['postgresql']['sysctl']['cfg']}"
  action  :nothing
end
