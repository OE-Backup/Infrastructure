#
# Cookbook Name:: oe-postgresql
# Recipe:: create_users
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#
# Database user creation
#
# Databag structure:
#
# {
#   "env_name": {
#     "user1": { "passw": "password1", "superuser": true }, # Will have superuser privs
#     "user2": { "passw": "password2" },                    # Will be a common user
#   }
# }

raise "#{cookbook_name}::#{recipe_name}: You must define node[postgresql][databag_item]" if node['postgresql']['databag_item'].nil?

if node['disable_encrypted_databags'].nil? or not node['disable_encrypted_databags']
  dbi = Chef::EncryptedDataBagItem.load(
    node['postgresql']['databag'], 
    node['postgresql']['databag_item']
  )
else
  dbi = Chef::DataBagItem.load(
    node['postgresql']['databag'],
    node['postgresql']['databag_item']
  )
end

# Get database users
db_users = dbi.to_hash()[node.chef_environment.split('-').last]

db_users.keys.each { |k|
  
  grants = ''
  grants <<= "SUPERUSER "   if db_users[k]['superuser']
  grants <<= "REPLICATION " if db_users[k]['replication']

  execute "create-db-user-#{k}" do
    action :run
    user    node['postgresql']['user']['name']
    command <<-EOC
      echo "CREATE USER #{k} \
        WITH UNENCRYPTED PASSWORD '#{db_users[k]['password']}' #{grants};" | psql 
    EOC
    not_if "echo \"SELECT usename FROM pg_catalog.pg_user WHERE usename = '#{k}';\" | psql -t | grep '#{k}'", :user => node['postgresql']['user']['name']
  end
} unless db_users.nil?

