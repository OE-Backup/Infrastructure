name             'oeinfra'
maintainer       'Open English Infrastructure Team'
maintainer_email 'infrastructure@openenglish.com'
license          'All rights reserved'
description      'Installs/Configures oeinfra'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.41'

%w(apt aws-fixes build-essential).each do |p|
depends "#{p}"
end 
