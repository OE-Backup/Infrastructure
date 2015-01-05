#!/bin/bash


##################
#                #
#  Cluster Prod  #
#                #
##################

###################################################################################################################
#                                                                                                                 #
#                                                       MASTER                                                    #
#                                                                                                                 #
###################################################################################################################

PGARCH=/mnt/postgresql/archived_wal
PGBACKUPS=/mnt/backups/postgresql
PGDATA=/var/lib/postgresql/9.2/main
PGEXEC=/var/lib/postgresql/ejecuciones
PGHBA=/etc/postgresql/9.2/main
PGLOG=/mnt/postgresql/log


########################
#                      #
# SAB o DOM o Dia Hab. #
#                      #
########################

dir_destino=$PGLOG/checklist_files

if [ `date +%u` -eq 6 ]
   then dir_destino=$PGLOG/checklist_files/sabado
fi
if [ `date +%u` -eq 7 ]
   then dir_destino=$PGLOG/checklist_files/domingo
fi


########################
#                      #
# archivos de salida   #
#                      #
########################
hoy=$(date +%Y-%m-%d)

listado_backups_master=$dir_destino/ls_bkp_master.out
salida_procesos_master=$dir_destino/ls_procesos_postgres_master.out
search_last_x_log_master=$dir_destino/outsearch_last_x_log_master.out
last_x_log_master=$dir_destino/last_x_log_master.out
last_wal_archivado=$dir_destino/last_wal_archivado.out
estado_replicacion=$dir_destino/estado_de_replica.out
status_fs=$dir_destino/espacio_en_disco.out
user_tables=$dir_destino/estado_tablas.out_$hoy
archivado_logs=$dir_destino/archivado_bkp_logs_master.out

report_fatal=$dir_destino/report_fatal.out 
report_warning=$dir_destino/report_warning.out 
report_error=$dir_destino/report_error.out

report_drop=$dir_destino/report_drop.out
report_alter=$dir_destino/report_alter.out

salida_error=$dir_destino/salida_error.out
salida_warning=$dir_destino/salida_warning.out
salida_fatal=$dir_destino/salida_fatal.out
salida_deadlocks=$dir_destino/salida_deadlocks.out

 table_growing_rate=$dir_destino/table_growing_rate.out;
 table_update_rate=$dir_destino/table_update_rate.out;
 table_autovacuum_rate=$dir_destino/table_autovacuum_rate.out;
 table_seq_read_rate=$dir_destino/table_seq_read_rate.out; 

########################
#                      #
# PROCESOS Y BLOQUEOS  #
#                      #
########################

# Verificar que no haya bloqueos en Master.
# Tambien que se esta replicando los entornos correspondientes ( 10.0.112.56, 10.16.1.4 )
ps -ef | grep postgres > $salida_procesos_master

# Me aseguro de estar en el directorio home de postgres
cd

###########################
#                         #
# VERIFICACION DE BACKUPS #
#                         #
###########################

cd $PGBACKUPS
ls -ltrR > $listado_backups_master

# Me aseguro de estar en el directorio home de postgres
cd

######################################
#                                    #
# VERIFICACION DE ARCHIVADO DE WALS  #
#                                    #
######################################

# Verifico que los entornos de replicacion estan sincronizados.
# Archivo donde alojare el nombre completo del ultimo WAL de $PGDATA/pg_xlog
cd $PGDATA/pg_xlog
ls -ltr | tail -1 > $search_last_x_log_master

# Me aseguro que sali del directorio $PGDATA/pg_xlog
cd

# Archivo donde alojare el nombre completo del ultimo WAL en uso.
cat $search_last_x_log_master | awk '{print $9}' > $last_x_log_master


# Archivo donde alojare el nombre completo del ultimo WAL de $PGARCH.
cd $PGARCH
ls -ltr | tail -1 > $last_wal_archivado

# Me aseguro que sali del directorio $PGARCH
cd

######################
#                    #
# MIRADA DE LOS LOGs #
#                    #
######################

# Cargo los archivos que contendran los detalles
cd $PGLOG

grep -A 1 FATAL postgresql-*.log > $report_fatal
grep -A 1 WARNING postgresql-*.log > $report_warning
grep -A 1 ERROR postgresql-*.log > $report_error

awk -F ':  ' '{print $2}' $report_error | sort |uniq -c |sort -rn > $salida_error
awk -F ':  ' '{print $2}' $report_warning | sort |uniq -c |sort -rn > $salida_warning
awk -F ':  ' '{print $2}' $report_fatal | sort |uniq -c |sort -rn > $salida_fatal


# Me aseguro de salir del directorio $PGLOG
cd

##############################
#		             #
# CONTROL DE DROP y ALTER    #
#			     #
##############################

# Entro al directorio donde estan los logs.
cd $PGLOG

grep -A 2 -B 1 DROP postgresql-*.log > $report_drop
grep -A 2 -B 1 ALTER postgresql-*.log > $report_alter

# Me aseguro de salir del directorio $PGLOG
cd

#########################
#                       #
# ESTADO DE REPLICACION #
#                       #
#########################

# Conecto a la base repmgr para ver el status de la replicacion
psql -d repmgr -c "select * from repmgr_lp20_prod.repl_status;" > $estado_replicacion

#################################
#                               #
# ESPACIO EN DISCO              #
#                               #
#################################

df -h > $status_fs


################
#              #
# DEADLOCKS    #
#              #
################

grep deadlock $report_error > $salida_deadlocks


#########################
#                       #
# ESTADO DE TABLAS      #
#                       #
#########################

# Conecto a la base lp20 
psql -d lp20 -c "select * from pg_stat_user_tables;" > $user_tables
psql -dlp20 -t   -c "select current_date, relname, n_live_tup  from pg_stat_user_tables order by n_live_tup desc limit 7 ;"  >>$table_growing_rate
psql -dlp20 -t   -c  "select current_date, relname, n_tup_upd  from pg_stat_user_tables order by n_tup_upd desc limit 7 ;"  >>$table_update_rate 
psql -dlp20 -t   -c "select current_date, relname, autovacuum_count , last_autovacuum  from pg_stat_user_tables order by autovacuum_count desc limit 7 ;" >> $table_autovacuum_rate
psql -dlp20 -t   -c "select current_date, relname, seq_scan , seq_tup_read  from pg_stat_user_tables order by seq_scan desc limit 7 ;" >> $table_seq_read_rate


#################################
#                               #
# LIMPIEZA DE LOGS A MANO       #
#                               #
#################################

# Guarga la fecha del dia anterior a zipear, en el formato indicado
ayer=$(date --date='1 day ago' +%Y-%m-%d)

# Entro al directorio donde estan los logs.
cd $PGLOG

# .tar.gz logs del dia anterior
tar --remove-files -cvf postgresql-$ayer.tar postgresql-$ayer*.log ;  gzip postgresql-$ayer.tar

# Mover a $PGLOG/backups
mv *gz backups

# Entro  a $PGLOG/backups para ver si se archivo correctamenteel tar con los archivos del dia anterio
cd $PGLOG/backups

# Guardo la ultima entrada en un archivo.
ls -ltr | tail -1 > $archivado_logs

# Salgo del directorio
cd

# Borrar archivos logs ya zipeados y guardados, por ahora a mano, en unos dias es un find con el rm (VER)

