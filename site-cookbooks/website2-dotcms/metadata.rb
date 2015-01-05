name             'website2-dotcms'
maintainer       'Infrastructure'
maintainer_email 'infrastructure@openenglish.com'
license          'All rights reserved'
description      'Installs/Configures website2-dotcms'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.14'

%w{ java openssl }.each do |cb|
  depends cb
end
depends		'oe-logs'
