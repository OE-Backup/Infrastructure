name             'lp2-amq'
maintainer       'Ariel Eusebi'
maintainer_email 'ariel.eusebi@openenglish.com'
license          'All rights reserved'
description      'Installs/Configures lp2-amq'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

%w{ java openssl }.each do |cb|
  depends cb
end

