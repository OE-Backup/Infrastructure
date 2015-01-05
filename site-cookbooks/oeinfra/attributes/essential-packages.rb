
default['oeinfra']['essential-packages'] = [ 
  { :name => 'sysstat', :version => nil },
  { :name => 'screen',  :version => nil },
  { :name => 'htop',    :version => nil },
  { :name => 'iotop',   :version => nil },
]
default[node.chef_environment.to_s]['oeinfra']['essential-packages'] = []
