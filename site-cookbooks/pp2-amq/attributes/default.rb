
# Following variables are based on pp2 and pp2-secrets databags.
# pp2-amq::amq => Enabled jdbc settings
default['amq']['jdbc_enabled'] = true

pp2_settings = Chef::DataBagItem.load("pp2", "amq")[node.chef_environment.to_s]
pp2_secrets = Chef::EncryptedDataBagItem.load("pp2", "amq-secrets")[node.chef_environment.to_s]

default['amq']['jdbc_user'] = pp2_settings["amq"]["jdbc_user"]
default['amq']['jdbc_host'] = pp2_settings["amq"]["jdbc_host"]
default['amq']['jdbc_port'] = pp2_settings["amq"]["jdbc_port"]
default['amq']['jdbc_db'] = pp2_settings["amq"]["jdbc_db"]
default['amq']['jdbc_port'] = pp2_settings["amq"]["jdbc_port"]
default['amq']['jdbc_port'] = pp2_settings["amq"]["jdbc_port"]
default['amq']['jdbc_datasource'] = pp2_settings["amq"]["jdbc_datasource"]
default['amq']['jdbc_initial_connections'] = pp2_settings["amq"]["jdbc_initialConnections"]
default['amq']['jdbc_max_connections'] = pp2_settings["amq"]["jdbc_maxConnections"]
default['amq']['jdbc_pass'] = pp2_secrets["amq"]["jdbc_pass"]
