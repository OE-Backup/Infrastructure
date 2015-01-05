#!/bin/bash
# Version 1.0 
# That script reverts FO. 
# It stops PS app in slave.  And it changes its cname in
# Route 53 AWS and starts tomcat7 in master.

PRD_PS_MASTER=10.0.113.15
PRD_PS_SLAVE=10.0.111.15
LOG_FILE=/var/log/promote.log
#AWS keys
export AWS_SECRET_KEY=
export AWS_ACCESS_KEY=
#
export EC2_URL="https://ec2.us-east-1.amazonaws.com"
export EC2_HOME=/opt/ec2
export PATH=$PATH:$EC2_HOME/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/bin
export JAVA_HOME=/usr/lib/jvm/java-7-oracle


function change_cname {
        MSG_CNAME_MODIFIED="`date`: Cname for prd-payment-service-i.oe-sys.com has changed from $PRD_PS_SLAVE to $PRD_PS_MASTER"
        MSG_CNAME_NOT_MODIFIED="`date`: Cname could not be modified, please check in AWS/Route53"
        cli53 rrdelete  oe-sys.com prd-payment-service-i && cli53 rrcreate -x 60 oe-sys.com  prd-payment-service-i A $PRD_PS_MASTER
        if [ $? -eq 0 ]
                then
                        echo $MSG_CNAME_MODIFIED >> $LOG_FILE
                else
                        echo $MSG_CNAME_NOT_MODIFIED >> $LOG_FILE && exit 1
        fi
}


function stop_tomcat7_locally {
        MSG_APP_RUNNING_ON_SLAVE="`date`: PS is STILL running on $PRD_PS_SLAVE, please check"
	MSG_APP_NOT_RUNNING_ON_SLAVE="`date`: PS is stopped on $PRD_PS_SLAVE"

        service tomcat7 stop
        sleep 180 
        curl --max-time 10 --request GET http://tolkien:thejohn@$PRD_PS_SLAVE:8080/payment_service/static/restapi.html | grep -e "HTTP Status - OK"
        if [ $? -eq 0 ]
                then
                        echo $MSG_APP_RUNNING_ON_SLAVE >> $LOG_FILE
			exit 1
                else
                        echo $MSG_APP_NOT_RUNNING_ON_SLAVE >> $LOG_FILE
        fi
}


function unjail_sg_in_master {
        PS_MASTER_SG_ID=(sg-a263aecd sg-39c53056)
        PS_MASTER_INSTANCE_ID=i-5852963c
        MSG_SG_NOT_APPLIED_ON_MASTER="`date`: SG ${PS_MASTER_SG_ID[*]} could not be applied on $PRD_PS_MASTER, please verify"

        MSG_SG_APPLIED_ON_MASTER="`date`: SG $PS_MASTER_SG_ID was successfully applied on $PRD_PS_MASTER"

        /opt/ec2/bin/ec2-modify-instance-attribute --group-id ${PS_MASTER_SG_ID[0]} $PS_MASTER_INSTANCE_ID --debug  &> $LOG_FILE
	sleep 10
        /opt/ec2/bin/ec2-modify-instance-attribute --group-id ${PS_MASTER_SG_ID[1]} $PS_MASTER_INSTANCE_ID --debug  &> $LOG_FILE
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

