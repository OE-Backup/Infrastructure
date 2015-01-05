oeinfra CHANGELOG
=================

This file is used to list changes made in each version of the oeinfra cookbook.

0.0.41
------
- [Emiliano Castagnari]
  - If node['access_groups'] is not specified setup defaults access groups

0.0.40
------
- [Emiliano Castagnari] 
  - Fixed resource redefinition when modifying group membership
  - moved group membership modifications to oeinfra::access_groups
  - members can be added or removed from a system group (access_group: action: add|remove)
  - A default access group is defined in attributes::default::oeinfra::access_groups
  - Added examples to oeinfra::access_groups

0.0.35
------
- [Miguel Landaeta] - TOOLS-2168: Add a Chef tag to indicate when instances in an environment are sandboxed or not.

0.0.34
------
- [Emiliano Castagnari] 
  - TOOLS-1812/2157: Create cron files in /etc/cron.d with oeinfra::cronjobs 

0.0.33
------
- [Miguel Landaeta] - TOOLS-2122: Restore DNS/Route53 features to oeinfra cookbook

0.0.32
------
- [Emiliano Castagnari] 
  - TOOLS-2106: oeinfra::disk fully functional and idempotent

0.0.31
------
- [Federico Aguirre] - TOOLS-2102: Remove appdynamics from oeinfra and add iotop to essentials packages

0.0.30
------
- [Emiliano Castagnari] - TOOLS-2089: Add user SSH private key and authorized keys

0.0.29
------
- [Miguel Landaeta] - TOOLS-1995: Modify Chef role base to allow bootstrap with Ubuntu 13.10.

0.0.28
------
- [Miguel Landaeta] - Set EC2 instance tags as Chef node attributes and tags

0.0.27
------
- [Ariel Eusebi] - Added infra users to adm group. Because we are not going to use sudo to check the logs.

0.0.26
------
- [Ariel Eusebi] - Added tomcat group verification. Now Anita cannot break everything.

0.0.25
------
- [Fede Aguirre] - Create appdynamics recipe.

0.0.24
------
- [Analia Lorenzatto] - Adding prd-pp2-banorte-master to take daily snapshots.

0.0.23
------
- [Analia Lorenzatto] - apt.rb modification to set /etc/apt/preferences and adding OE internal mirror.

0.0.22
------
- [Ariel Eusebi] - settag.rb modification to set instance name/prompt from Chef node name.

0.0.21
------
- [Analia Lorenzatto] - Add samhain.rb recipe to install Samhain IDS package.

0.0.20
------
- [Ariel Eusebi] - Add DC members to tomcatX and adm groups.

0.0.19
------
- [Ariel Eusebi] - Set nfs server as variable in autohome.rb

0.0.18
------
- [Ariel Eusebi] - Added pp2 environments to case eval in settag.rb
- [Ariel Eusebi] - Added route53 record creation in settag.rb

0.0.16
------
- [Martin Barriviera] - Fixed sudoers - for real this time

0.0.15
------
- [Emiliano Castagnari] - Improved essential-packages functionality

0.0.14
------
- [Martin Barriviera] - Fixed sudoers

0.0.12
------
- [Ariel Eusebi] - Added autohome recipe for centralized home directories

0.0.10
------
- [Ariel Eusebi] - Added cronjob for spotfirewp backup in cron-node.rb
- [Ariel Eusebi] - Added cronjob for spotfire backup in cron-node.rb

0.0.7
-----
- [Ariel Eusebi] - Provide optsync recipe.

0.0.6
-----
- [Miguel Landaeta] - Provide cron-node recipe.

0.1.0
-----
- [your_name] - Initial release of oeinfra

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
