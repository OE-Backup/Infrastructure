#!/bin/bash
# Version 1.0 
# That script is ran manually to ireverts FO.

PRD_AS_MASTER=10.0.112.12
PRD_AS_SLAVE=10.0.111.12
LOG_FILE=/var/log/promote.log
export AWS_SECRET_KEY=ReREcUhbkkla9YlI4hdqJzFlC6RdTJDZQvnEHU/8
export AWS_ACCESS_KEY=AKIAI643RFROZDI5WPQQ
export EC2_URL="https://ec2.us-east-1.amazonaws.com"
export EC2_HOME=/opt/ec2
export PATH=$PATH:$EC2_HOME/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/bin
export JAVA_HOME=/usr/lib/jvm/java-7-oracle


function change_cname {
        MSG_CNAME_MODIFIED="`date`: Cname for prd-account-service-i.oe-sys.com account-service changed from $PRD_AS_MASTER to $PRD_AS_SLAVE"
        MSG_CNAME_NOT_MODIFIED="`date`: Cname could not be modified, please check in AWS/Route53"
        cli53 rrdelete  oe-sys.com prd-account-service-i && cli53 rrcreate -x 60 oe-sys.com  prd-account-service-i A $PRD_AS_MASTER
        if [ $? -eq 0 ]
                then
                        echo $MSG_CNAME_MODIFIED >> $LOG_FILE
                else
                        echo $MSG_CNAME_NOT_MODIFIED >> $LOG_FILE && exit 1
        fi
}


function stop_tomcat7_locally {
        MSG_APP_RUNNING_ON_SLAVE="`date`: AS is STILL running on $PRD_AS_SLAVE, please check"
	MSG_APP_NOT_RUNNING_ON_SLAVE="`date`: AS is stopped on $PRD_AS_SLAVE"

        service tomcat7 stop
        sleep 180 
        curl --max-time 10 --request GET http://tolkien:thejohn@$PRD_AS_SLAVE:8080/account_service/static/restapi.html | grep -e "HTTP Status - OK"
        if [ $? -eq 0 ]
                then
                        echo $MSG_APP_RUNNING_ON_SLAVE >> $LOG_FILE
			exit 1
                else
                        echo $MSG_APP_NOT_RUNNING_ON_SLAVE >> $LOG_FILE
        fi
}


function unjail_sg_in_master {
        AS_MASTER_SG_ID=(sg-06ce2e69 sg-37c53058)
        AS_MASTER_INSTANCE_ID=i-a003d4dd
        MSG_SG_NOT_APPLIED_ON_MASTER="`date`: SG ${AS_MASTER_SG_ID[*]} could not be applied on $PRD_AS_MASTER, please verify"

        MSG_SG_APPLIED_ON_MASTER="`date`: SG $AS_MASTER_SG_ID was successfully applied on $PRD_AS_MASTER"

        /opt/ec2/bin/ec2-modify-instance-attribute --group-id ${AS_MASTER_SG_ID[0]} $AS_MASTER_INSTANCE_ID --debug  &> $LOG_FILE
	sleep 10
        /opt/ec2/bin/ec2-modify-instance-attribute --group-id ${AS_MASTER_SG_ID[1]} $AS_MASTER_INSTANCE_ID --debug  &> $LOG_FILE
        if [ $? -eq 0 ]
                then
                        echo $MSG_SG_APPLIED_ON_MASTER >> $LOG_FILE
                else
                        echo $MSG_SG_NOT_APPLIED_ON_MASTER >> $LOG_FILE
                        exit 1
        fi
}

########
# MAIN #
########
change_cname && stop_tomcat7_locally && unjail_sg_in_master

