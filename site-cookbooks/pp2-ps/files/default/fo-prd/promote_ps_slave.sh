#!/bin/bash
# Version 1.0 
# That script is ran by cron every X minutes.
# It checks if PS app is upp in master.  If not, it changes its cname in
# Route 53 AWS and starts tomcat7 in slave.

PRD_PS_MASTER=10.0.113.15
PRD_PS_SLAVE=10.0.111.15
LOG_FILE=/var/log/promote.log
# AWS keys
export AWS_SECRET_KEY=
export AWS_ACCESS_KEY=
#
export EC2_URL="https://ec2.us-east-1.amazonaws.com"
export EC2_HOME=/opt/ec2
export PATH=$PATH:$EC2_HOME/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/bin
export JAVA_HOME=/usr/lib/jvm/java-7-oracle


function check_app {
        MSG_APP_RUNNING="`date`: http://prd-payment-service-i.oe-sys.com:8080/payment_service/static/restapi.html  is responding with no problems"
        MSG_APP_NOT_RUNNING="`date`: http://prd-payment-service-i.oe-sys.com:8080/payment_service/static/restapi.html is NOT responding, please check it."
        curl --max-time 10 --request GET http://tolkien:thejohn@prd-payment-service-i.oe-sys.com:8080/payment_service/static/restapi.html | grep -e "HTTP Status - OK"
        if [ $? -eq 0 ]
                then
                        echo $MSG_APP_RUNNING >> $LOG_FILE 
                        exit 1
                else
                        echo $MSG_APP_NOT_RUNNING >> $LOG_FILE
        fi
}


function check_if_app_is_running_in_master {
        MSG_APP_RUNNING_ON_MASTER="`date`: PS is successfully running on $PRD_PS_MASTER"
        MSG_APP_NOT_RUNNING_ON_MASTER="`date`: App is not running on $PRD_PS_MASTER"

        curl --max-time 10 --request GET http://tolkien:thejohn@$PRD_PS_MASTER:8080/payment_service/static/restapi.html | grep -e "HTTP Status - OK"
        if [ $? -ne 0 ]
                then
                        echo $MSG_APP_NOT_RUNNING_ON_MASTER >> $LOG_FILE
                        python /opt/FO/mail_app_not_running_in_master.py
                else
                        echo $MSG_APP_RUNNING_ON_MASTER >> $LOG_FILE
                        exit 1
        fi
}


function change_cname {
        MSG_CNAME_MODIFIED="`date`: Cname for prd-payment-service-i.oe-sys.com has changed from $PRD_PS_MASTER to $PRD_PS_SLAVE"
        MSG_CNAME_NOT_MODIFIED="`date`: Cname could not be modified, please check in AWS/Route53"
        cli53 rrdelete  oe-sys.com prd-payment-service-i && cli53 rrcreate -x 60 oe-sys.com  prd-payment-service-i A $PRD_PS_SLAVE
        if [ $? -eq 0 ]
                then
                        echo $MSG_CNAME_MODIFIED >> $LOG_FILE
                else
                        echo $MSG_CNAME_NOT_MODIFIED >> $LOG_FILE && exit 1
        fi
}


function restart_tomcat7_locally {
        MSG_APP_RUNNING_ON_SLAVE="`date`: PS is successfully running on $PRD_PS_SLAVE"
        MSG_APP_NOT_RUNNING_ON_SLAVE="`date`: PS is not running in $PRD_PS_SLAVE, please check"
        MSG_RESTARTING_TOMCAT="`date`: Waiting for Tomcat7 on $PRD_PS_SLAVE to be restarted"

        sudo service tomcat7 restart && echo $MSG_RESTARTING_TOMCAT >> $LOG_FILE
        sleep 180 
        curl --max-time 10 --request GET http://tolkien:thejohn@$PRD_PS_SLAVE:8080/payment_service/static/restapi.html | grep -e "HTTP Status - OK"
        if [ $? -eq 0 ]
                then
                        echo $MSG_APP_RUNNING_ON_SLAVE >> $LOG_FILE
                        python /opt/FO/mail_app_running.py
                else
                        echo $MSG_APP_NOT_RUNNING_ON_SLAVE >> $LOG_FILE
                        python /opt/FO/mail_app_not_running.py
        fi
}

function jail_sg_in_master {
        PS_MASTER_SG_ID=sg-e3b7178c
        PS_MASTER_INSTANCE_ID=i-300c3456
#	PS_MASTER_INSTANCE_ID=i-593b4039 Slave-> to make proofs
        MSG_SG_NOT_APPLIED_ON_MASTER="`date`: SG $PS_MASTER_SG_ID could not be applied on $PRD_PS_MASTER, please verify"

        MSG_SG_APPLIED_ON_MASTER="`date`: SG $PS_MASTER_SG_ID was successfully applied on $PRD_PS_MASTER"

        /opt/ec2/bin/ec2-modify-instance-attribute --group-id $PS_MASTER_SG_ID $PS_MASTER_INSTANCE_ID --debug  &> $LOG_FILE
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
check_app && check_if_app_is_running_in_master && change_cname && jail_sg_in_master && restart_tomcat7_locally


