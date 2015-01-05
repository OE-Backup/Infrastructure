# 
# Cookbook Name:: oe-tomcat
# Recipe:: libs
#
# Description:
#  Recipe to add or remove jars from tomcat lib_dir.
#
# Parameters:
#  node['tomcat']['jars'] = { :add => [], :remove => [] }
#
#   - :add 
#     Array that contains a list of hashes with the filename and
#     a digest (sha256sum) of the jars to be added.
#     Example:
#     :add => [
#       { :name => 'jdbc-postgresql-9.2.jar',  :digest => '123qweq34werf23r34tWDGwetr' },
#       { :name => 'some-super-dooperlib.jar', :digest => 'oiu2350uwefokneg0u32450urr' },
#     ]
#
#   - :remove
#     Array that contains a list of filenames of the jars to be removed.
#     Example:
#     :remove => [ 'useless-lib.jar', 'dont-want-this.jar' ]
#

if node['tomcat']['jars'].nil? then
  Chef::Log.info("Node will not load any additional jars")
  return
end

%w{java tomcat}.each { |i|

  # Add libs to tomcat lib dir
  unless node[i]['jars'][:add].nil? then
    
    node[i]['jars'][:add].each { |jar|
      
      dst_prefix = jar[:dst].nil? ? node[i]['lib_dir'] : jar[:dst]
      
      remote_file "#{dst_prefix}/#{jar[:name]}" do
        action   :create_if_missing
        source   "#{node[i]['libs_url']}/#{jar[:name]}"
        checksum jar[:digest]
        owner    node['tomcat']['user']
        group    node['tomcat']['group']
        mode     '0644'
      end
    }
    
  end

  # Remove libs from tomcat lib dir
  unless node[i]['jars'][:remove].nil? then
    
     node[i]['jars'][:remove].each { |jar|
      Chef::Log.info("Removing jar file #{node[i]['lib_dir']}/#{jar}")

      file "#{node[i]['lib_dir']}/#{jar}" do
        action   :delete
      end
    }

  end

}
