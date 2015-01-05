#
# Cookbook Name:: oe-logs
# Recipe:: log
#
# Copyleft 2014, Open English
#
# Modify, redistribute, it's Free Software
#
# Attributes
#
#   node['oe-logs']['services'] = {
#     'tomcat'   => { ... },
#     'postgres' => { ... },
#   }
#
#   Configuration Hash:
#   {
#     'prefix':       '/mnt/log/tomcat7',
#     'symlink':      '/var/log/tomcat7',
#     'owner':        '<user>',
#     'group':        '<group>',
#   }


node['oe-logs']['services'].each { |svc, conf|
  
  # It could happen that a service defines it logging directory
  # and clashes with this. This avoids redefining it
  unless resources.include?("directory[#{conf['log']['prefix']}]") then
    directory conf['log']['prefix'] do
      action    :create
      owner     conf['log']['owner']
      group     conf['log']['group']
      mode      0755
      recursive true
    end
  end

  # If we don't want to symlink, get to the next service
  next if conf['log']['symlink'].nil? 
  
  # Directory exists and it has logs in it ... move them to the
  # appropiate destination
  ruby_block "#{svc}-move-old-logs" do
    block do
      require 'fileutils'
      if File.directory?(conf['log']['symlink']) 
        entries = Dir.entries(conf['log']['symlink']).select { |e| 
          not e =~ /^\./ 
        }.map { |f| 
          "#{conf['log']['symlink']}/#{f}"
        }
        FileUtils.mv entries, conf['log']['prefix']
      end
    end
    action    :create
    only_if   { not File.symlink?(conf['log']['symlink']) }
    #notifies  :stop,   "service[#{svc}]", :immediately
    notifies  :delete, "directory[#{conf['log']['symlink']}]", :immediately
    #notifies  :start,  "service[#{svc}]", :immediately
  end

  # If directory exists and it is not a symlink
  # remove it.
  directory conf['log']['symlink'] do
    action    :nothing
    only_if   { not File.symlink?(conf['log']['symlink']) }
    recursive true
  end

  link conf['log']['symlink'] do
    link_type :symbolic
    owner     'root'
    group     'root'
    to        conf['log']['prefix']
  end
}

