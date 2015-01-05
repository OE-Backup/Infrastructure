oe-monitoring CHANGELOG
=======================

This file is used to list changes made in each version of the oe-monitoring cookbook.

0.2.1 
-----
- [Emiliano Castagnari]
  - oe-monitoring::appdynamics: Fixed user attribute for tomcat
  - oe-monitoring::datadog_alert: Fixed missing attribute

0.1.9
-----
- [Emiliano Castagnari]
  - Added dotcms entry for oe-monitoring::datadog

0.1.8
-----
- [Emiliano Castagnari]
  - Added loggly recipe

0.1.7
-----
- Federico Aguirre [TOOLS-2105] - Add a service restart after install on Datadog and Monit

0.1.6
-----
- Analia Lorenzatto - Added validation at the moment of intallation datadog-agent and retries to 5.

0.1.5
-----
- Federico Aguirre - TOOLS-2070 Adding a patch to oe-monitoring::appdynamics to make it compatible with old cookbooks that are not using oe-tomcat (2014-02-05)

0.1.4
-----
- Federico Aguirre - Add JAVA_OPTIONS key to monit (2014-02-04)

0.1.3
-----
- Federico Aguirre - Change Appdynamics credentials to third-party data bag (2014-02-04)

0.1.2
-----
- [Federico Aguirre] - Changes to oe-monitoring adding ['monitoring'] key to some attributes (2014-02-03)

0.1.1
-----
- [Federico Aguirre] - Monit was added to oe-monitoring (2014-01-24)

0.1.0
-----
- [Federico Aguirre] - AppDynamics was added to oe-monitoring (2014-01-21)

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
