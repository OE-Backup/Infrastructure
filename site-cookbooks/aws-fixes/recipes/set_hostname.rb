execute "set hostname" do
  command "echo 127.0.0.1 `hostname -s` >> /etc/hosts"
  user "root"
  action :run
  not_if "cat /etc/hosts | grep `hostname`"
end