oe-tomcat CHANGELOG
====================

This file is used to list changes made in each version of the oe-tomcat cookbook.

1.3.7
-----
- [Emiliano Castagnari] 
  - Recipe oe-tomcat::log4j fixed if attribute node.tomcat.log4j is missing
  - Recipe oe-tomcat::propfiles removed duplicated attribute properties_prefix
  - Recipe oe-tomcat::propfiles fixed Chef::Exceptions::FileTypeMismatch

1.3.6
-----
- [Emiliano Castagnari] 
  - Recipe oe-tomcat::appdirs supports symlinks

1.3.5
-----
- [Emiliano Castagnari] 
  - Recipe oe-tomcat::log4j now supports loggers

1.3.4
-----
- [Emiliano Castagnari] 
  - Recipe oe-tomcat::appdirs to create additional application directories

1.3.3
-----
- [Emiliano Castagnari] 
  - Bugfix on datasource resource

1.3.2
-----
- [Emiliano Castagnari] 
  - Renamed some Tomcat library methods
    Tomcat.get_databag_items => Tomcat.databag_items
    new: Tomcat.databag_item

1.3.1
-----
- [Emiliano Castagnari] 
  - oe-tomcat::context recipe to generate context.xml 
    (or the name you wish to give to it) config file

1.3.0
-----
- [Emiliano Castagnari] 
  - oe-tomcat::log4j recipe to generate log4j.xml config file

1.2.2
-----
- [Emiliano Castagnari] 
  - bugfix when some databag items are encrypted and some are not

 1.2.1
------
- [Emiliano Castagnari] 
  - Implemented the Tomcat library to read users and roles from a databag
  - Implemented tomcat-users.xml template

 1.2.0
------
- [Emiliano Castagnari] 
  - Discarded dependency on opscode tomcat cookbook
  - Included propfiles in default recipe with conditional execution (tomcat['propfiles'].nil?)
  - Added recipe to handle packages
  - Added recipe to handle service
  - Moved oe-tomcat::tomcat to oe-tomcat::config
  - Conditionaly deploying oe-probe (tomcat['deploy_probe'] = true)
  - Missing users and roles
  - Works with Vagrant (when propfiles do not use an encrypted data bag)

1.1.1
-----
- [Emiliano Castagnari] 
  - oe-tomcat::libs supports optional attribute :dst in node.tomcat.jars
  - FIXME: should go to some generic thing (resource, library, definition)

1.1.0
-----
- [Emiliano Castagnari] 
  - Added template context.xml
  - Refactor oe-tomcat::propfiles to support environment and context properties files
  - Environment properties loads from /etc/default/tomcatX
  - Context properties loads from context.xml

1.0.7
-----
- [Analia Lorenzatto] - Commented notifies in oe-tomcat::probe recipe.

1.0.6
-----
- [Analia Lorenzatto] - Added JMX settings.

1.0.5
-----
- [Analia Lorenzatto] - Added probe recipe.

1.0.4
-----
- [Analia Lorenzatto] - Added ssl recipe into tomcat one.

1.0.3
-----
- [Emiliano Castagnari] - If node['tomcat']['jars'] is not defined, ignore recipe libs.rb

1.0.1
-----
- [Emiliano Castagnari] - Implement oe-logs::logrotate

1.0.0
-----
- [Analia Lorenzatto] - Release 0.0.5 tomcat-all was renamed to oe-tomcat. New release available: 1.0.0.

0.0.5
-----
- [Emiliano Castagnari] - Moved resource default/tomcatX to propfiles

0.0.4
-----
- [Emiliano Castagnari] - delayed service restart
- [Emiliano Castagnari] - propfiles recipe to generate an environment properties file

0.0.3
-----
- [Emiliano Castagnari] - libs recipe to add or remove libraries

0.0.1
-----
- [Ariel Eusebi] - Initial release of oe-tomcat

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
