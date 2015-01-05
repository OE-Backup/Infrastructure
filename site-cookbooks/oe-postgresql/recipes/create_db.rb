#
# Cookbook Name:: oe-postgresql
# Recipe:: create_db
#
# Copyleft 2014, Open English
#
# Modify redistribute, enjoy
#
# Database creation:
#   Databases are specified on a Node/Environment/Role attribute
#   array. Each element is a hash containing the following attributes:
#     - name        (required)
#     - owner       (required)
#     - encoding    (optional)
#     - locale      (optional)
#     - tablespace  (optional)
#
#   Example:
#     "postgresql": {
#       "databases": [
#         {
#           "name":  "some_db_1",
#           "owner": "dbowner1"
#         },
#         {
#           "name":       "some_db_2",
#           "owner":      "dbowner2",
#           "encoding":   "utf8",
#           "locale":     "en_us",
#           "tablespace": "something"
#         }
#       ]
#     }
#

return if node['postgresql']['databases'].nil?

# Create databases
node['postgresql']['databases'].each { |db|
  
  raise "#{cookbook_name}::#{recipe_name}: name attribute is required"  if db['name'].nil? 
  raise "#{cookbook_name}::#{recipe_name}: owner attribute is required" if db['owner'].nil?

  create_opts = ''
  create_opts <<= "-O #{db['owner']} "
  create_opts <<= "-E #{db['encoding']} "   unless db['encoding'].nil?
  create_opts <<= "-l #{db['locale']} "     unless db['locale'].nil?
  create_opts <<= "-D #{db['tablespace']} " unless db['tablespace'].nil?

  # Create database
  execute "create-db-#{db['name']}" do 
    action  :run
    user    node['postgresql']['user']['name']
    command <<-EOC
      createdb #{create_opts} #{db['name']}
    EOC
    not_if "echo \"SELECT datname FROM pg_database WHERE datname = '#{db['name']}';\" | psql -t | grep '#{db['name']}'", :user => node['postgresql']['user']['name']
  end
}

