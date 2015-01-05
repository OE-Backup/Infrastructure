package "python-pip"

package "python-boto" do
  action :remove
end

%w(boto cli53).each do |pipi|
  execute "install #{pipi}" do
    command "pip install --upgrade #{pipi}"
    user "root"
    action :run
#    not_if { ::File.exists?("/usr/local/bin/cli53")}
  end
end
