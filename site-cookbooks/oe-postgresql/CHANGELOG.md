oe-postgresql CHANGELOG
=======================

Cookbook to install and configure postgresql database

0.5.1
-----
- [Emiliano Castagnari]
  - If node[disable_encrypted_databags] is enabled, do not use Chef::EncryptedDataBag
  - Do not use ssh_keys if nil

0.5.0
-----
- [Emiliano Castagnari]
  - Added documentation to template
  - Config hash divided into sections, matching template ones
  - postgresql::server::type is now optional. If not specified, try to guess it from node.name
  - repmgr::config::node is now optional. If not specified, try to guess it from node.name

0.4.1
-----
- [Emiliano Castagnari]
  - Minor fixes on missing attributes

0.4.0
-----
- [Emiliano Castagnari]
  - Fixed log directory creation order

0.3.3
-----
- [Emiliano Castagnari]
  - Fixed default attribute for user home

0.3.2
-----
- [Emiliano Castagnari] 
  - Added dependency on ssh_known_hosts LWRP

0.3.1
-----
- [Emiliano Castagnari] 
  - SSH keys implemented inside oe-postgresql

0.3.0
-----
- [Emiliano Castagnari] 
  - SSH keys implemented through oeinfra::ssh_keys

0.2.0
-----
- [Emiliano Castagnari] 
  - Documentation on usage

0.1.6
-----
- [Emiliano Castagnari] 
  - Support for readonly server type implemented

0.1.5
-----
- [Emiliano Castagnari] 
  - Manage repmgrd as a service

0.1.4
-----
- [Emiliano Castagnari] 
  - Fixed service dependency

0.1.3
-----
- [Emiliano Castagnari] 
  - Slave implemented

0.1.2
-----
- [Emiliano Castagnari] 
  - Refactor users databag to include privileges (superuser and replication)

0.1.0
-----
- [Emiliano Castagnari] 
  - Master server is fully functional with replication enabled

0.0.1
-----
- [Emiliano Castagnari] 
  - Initial release of oe-postgresql

- - -
