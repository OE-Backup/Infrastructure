#!/bin/bash

lsof -u dotcms > /tmp/lsof.lst

felix=`cat /tmp/lsof.lst | grep "/opt/dotcms/dotserver/dotCMS/WEB-INF/felix/" | wc -l`
static_plugins=`cat /tmp/lsof.lst | grep "/opt/dotcms/dotserver/plugins/" | wc -l`
assets=`cat /tmp/lsof.lst | grep "/srv/assets" | wc -l`
tomcat=`cat /tmp/lsof.lst | grep "/opt/dotcms/dotserver/tomcat" | wc -l`
tot=`cat /tmp/lsof.lst | wc -l`
oth=$(( ${tot} - ${tomcat} - ${assets} - ${static_plugins} - ${felix}))
ts=`date "+%F %T"`

cat << EOF
${ts} - OF - Open Files Report
${ts} - OF - ---------------------------
${ts} - OF - Dynamic plugins: ${felix}
${ts} - OF - Static plugins: ${static_plugins}
${ts} - OF - Assets: ${assets}
${ts} - OF - Tomcat: ${tomcat}
${ts} - OF - Other: ${oth}

${ts} - OF - Total: ${tot}
${ts} - OF - Limit: `su -c "ulimit -n" dotcms`
${ts} - OF - ---------------------------
EOF

