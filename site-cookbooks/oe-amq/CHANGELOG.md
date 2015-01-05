oe-amq CHANGELOG
=================

This file is used to list changes made in each version of the oe-amq cookbook.

1.1.4
-----
- Federico Aguirre - Move ACTIVEMQ_SUNJMX_CONTROL from INIT script to DEFAULT script

1.1.3
-----
- Analia Lorenzatto - Set: ['monitoring']['appdynamics']['enabled'] = true as default attribute into oe-amq cookbook.

1.1.2
-----
- Analia Lorenzatto - Replaced: ACTIVEMQ_PIDFILE="$ACTIVEMQ_DATA/activemq-`hostname`.pid" by ACTIVEMQ_PIDFILE="$ACTIVEMQ_DATA/activemq.pid".

1.1.1
-----
- Analia Lorenzatto - Added Java jdk version to install JDK-7 instead of JDK-6.

1.1.0
-----
- Analia Lorenzatto - Add postgresql-9.2-1002-jdbc4.jar, sets default configurations's parameters, set appdynamic flag's configuration.
			
1.0.2
-----
- Analia Lorenzatto - Added monitoring behaviour by including oe-monitoring::appdynamics.

1.0.1
-----
- Analia Lorenzatto - Included oe-logs::log recipe.

1.0.0
-----
- Analia Lorenzatto - Included oe-logs::logrotate recipe.

0.0.4
-----
- Analia Lorenzatto - Removed unused templates in the cookbook.

0.0.3
-----
- Analia Lorenzatto - Enabled postgres lib for AMQ: postgresql-9.2-1002-jdbc4.jar.

0.0.2
-----
- Analia Lorenzatto - Added default properties  in oe-amq cookbook as default attributes.

0.0.1
-----
- Analia Lorenzatto - Initial release of oe-amq

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
