name             'oe-postgresql'
maintainer       'Emiliano Castagnari'
maintainer_email 'emiliano.castagnari@openenglish.com'
license          'GPLv2'
description      'Installs/Configures oe-postgresql'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.1'

depends 'apt'
depends 'ssh_known_hosts'
depends 'oe-logs'

