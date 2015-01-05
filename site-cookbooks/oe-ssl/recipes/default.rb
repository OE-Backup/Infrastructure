#
# Cookbook Name:: ssl
# Recipe:: default
#
# Copyleft 2013, Open English
#

# Get the SSL domain attribute and transform it
# to a usable databag item name

if not defined?(node['ssl']['type'])
  #raise Chef::Exceptions::AttributeNotFound 'SSL type is not defined' 
  #raise 'SSL type is not defined' 
end

case node['ssl']['type']

  when 'pem'
    include_recipe 'oe-ssl::pem'

  when 'keystore'
    include_recipe 'oe-ssl::keystore'

  when 'pkcs12'
    include_recipe 'oe-ssl::pkcs12'

#  else
#    raise Chef::Exceptions::ArgumentError

end


