name             'lp2-ca'
maintainer       'Open English'
maintainer_email 'infrastructure@openenglish.com'
license          'All rights reserved'
description      'Installs/Configures lp2-ca'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.2'

depends 'apache2'
depends 'oe-ssl'
depends 'oe-tomcat'

