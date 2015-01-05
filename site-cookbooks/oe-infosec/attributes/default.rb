default['oe-infosec']['rsyslog']['URL'] = "loganalizer.oe-sys.com"
default['oe-infosec']['rsyslog']['PORT'] = 1670
default['oe-infosec']['rsyslog']['PORT2'] = 1680
default['oe-infosec']['samhain']['URL'] = "https://s3.amazonaws.com/infra-packages/samhain_3.0.13-1_amd64.deb"
default['oe-infosec']['rsyslog']['postgresql'] = <<EOF
#Config for Postgres Server
if $programname == 'postgres' and $msg contains_i 'grant' then @@#{node['oe-infosec']['rsyslog']['URL']}:#{node['oe-infosec']['rsyslog']['PORT']}
& ~
if $programname == 'postgres' and $msg contains_i 'Peer authentication failed for user' then @@#{node['oe-infosec']['rsyslog']['URL']}:#{node['oe-infosec']['rsyslog']['PORT']}
& ~
EOF

default['oe-infosec']['rsyslog']['tomcat'] = <<EOF
# Config for Tomcat Server
$ModLoad imfile
$InputFileName /var/log/tomcat#{node['tomcat']['base_version']}/catalina.out
$InputFileTag tomcat:
$InputFileStateFile stat-catalina
$InputFileSeverity info
$InputRunFileMonitor
$InputFilePollInterval 1
if $programname == 'tomcat' and $msg contains 'Stopping' or $msg contains 'Starting' then @@#{node['oe-infosec']['rsyslog']['URL']}:#{node['oe-infosec']['rsyslog']['PORT']}
& ~
EOF
