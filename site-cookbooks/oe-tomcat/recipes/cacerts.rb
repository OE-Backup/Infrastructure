#
# Cookbook Name:: oe-tomcat
# Recipe:: cacerts
#
# Description:
#
#   TODO
#
# Parameters:
#   - TODO
#

include_recipe 'oe-tomcat::service'

certs_dir = node['tomcat']['ssl']['certs_dir']

# CA certs directory for PEMs
directory certs_dir do
  action    :create
  mode      '0775'
  recursive true
end

databag      = node['tomcat']['ssl']['databag']
databag_item = node['tomcat']['ssl']['databag_item']

# Databag item in the form of { 'cer_alias1' => 'cert', ... }
cacerts  = Chef::DataBagItem.load(databag, databag_item).to_hash

keystore      = node['tomcat']['ssl']['keystore']
keystore_pass = node['tomcat']['ssl']['keystore_pass']

cacerts.each { |cert_alias, certificate|
  # Discard the databag metadata
  next if [ 'id', 'chef_type', 'data_bag' ].include?(cert_alias)

  file  "#{certs_dir}/#{cert_alias}.pem" do
    action    :create
    owner     'root'
    group     'root'
    mode      0644
    content   "#{certificate}"
    notifies  :run, "execute[update-CACertFile-with-#{cert_alias}]", :immediately
  end

  #FIXME:
  # The Begin/Rescue block doesn't work because the scope of the
  # code raising the exception.
  # The two phase chef-client run, first generates the resource,
  # and then converges the node. The resource generation does not
  # raises the exception, as the resource is not run.
  begin
    execute "update-CACertFile-with-#{cert_alias}" do
      action  :nothing
      umask   0002
      command <<-EOC
        keytool -importcert \
          -noprompt \
          -trustcacerts \
          -keystore  "#{keystore}" \
          -alias     "#{cert_alias}" \
          -file      "#{certs_dir}/#{cert_alias}.pem" \
          -storepass "#{keystore_pass}" && \
            touch #{certs_dir}/#{cert_alias}.pem.added
      EOC
      creates     "#{certs_dir}/#{cert_alias}.pem.added"
      subscribes  :run, "file[#{certs_dir}/#{cert_alias}.pem]", :immediately
      notifies    :restart, "service[tomcat]", :delayed
      ignore_failure true
    end
  end
}

