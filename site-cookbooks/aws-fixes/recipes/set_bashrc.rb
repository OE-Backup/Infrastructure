file "/etc/bashrc" do
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
end
