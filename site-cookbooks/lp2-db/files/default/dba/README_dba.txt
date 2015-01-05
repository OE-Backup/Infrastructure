Infrastructure team through Chef only take care of installation and configuration of DB nodes.

The setup of replication and clustering features are on the realm of DBA team.

Usual tasks performed by DBAs:

repmgr -f /var/lib/postgresql/repmgr/repmgr.conf --verbose master register # (register master node)
nohup  repmgr -D $PGDATA -d repmgr -p 5432 -U repmgr -R postgres -w 50  --verbose standby clone 10.16.0.169 # (clone db master from a slave)
repmgrd --monitoring-history -f /var/lib/postgresql/repmgr-REL2_0_STABLE/repmgr.conf > /mnt/postgresql/log/repmgr.log 2>&1 & (start repmgrd in a slave)
(Clean up $PGDATA folder in slave)
(Setup repmgr.conf configuration in slaves, in /var/lib/postgresql/repmgr/repmgr.conf)
