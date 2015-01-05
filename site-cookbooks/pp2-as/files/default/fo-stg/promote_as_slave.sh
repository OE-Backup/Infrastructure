#!/bin/bash
# Version 1.0 
# That script is ran by cron every X minutes.
# It checks if AS app is up in account-service.  If not, it changes its cname in
# Route 53 AWS and starts tomcat7 in slave.

STG_AS_MASTER=10.16.0.12
STG_AS_SLAVE=10.16.1.12
LOG_FILE=/var/log/promote.log
export AWS_SECRET_KEY=ReREcUhbkkla9YlI4hdqJzFlC6RdTJDZQvnEHU/8
export AWS_ACCESS_KEY=AKIAI643RFROZDI5WPQQ
export EC2_URL="https://ec2.eu-west-1.amazonaws.com"
export EC2_HOME=/opt/ec2
export PATH=$PATH:$EC2_HOME/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/bin
export JAVA_HOME=/usr/lib/jvm/java-7-oracle


function check_app {
	MSG_APP_RUNNING="`date`: http://stg-account-service-i.thinkglish.com:8080/account_service/static/restapi.html  is responding with no problems"
        MSG_APP_NOT_RUNNING="`date`: http://stg-account-service-i.thinkglish.com:8080/account_service/static/restapi.html is NOT responding, please check it."
        
	curl --head --max-time 10  http://tolkien:thejohn@stg-account-service-i.thinkglish.com:8080/account_service/static/restapi.html | grep -e "200 OK"
	if [ $? -eq 0 ]
                then
                        echo $MSG_APP_RUNNING >> $LOG_FILE 
                        exit 1
                else
                        echo $MSG_APP_NOT_RUNNING >> $LOG_FILE
        fi
}


function check_if_app_is_running_in_master {
        MSG_APP_RUNNING_ON_MASTER="`date`: AS is successfully running on $STG_AS_MASTER"
        MSG_APP_NOT_RUNNING_ON_MASTER="`date`: App is not running on $STG_AS_MASTER"
	
	curl --head --max-time 10  http://tolkien:thejohn@$STG_AS_MASTER:8080/account_service/static/restapi.html | grep -e "200 OK"
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
        MSG_CNAME_MODIFIED="`date`: Cname for stg-account-service-i.thinkglish.com account-service changed from $STG_AS_MASTER to $STG_AS_SLAVE"
        MSG_CNAME_NOT_MODIFIED="`date`: Cname could not be modified, please check in AWS/Route53"
        cli53 rrdelete  thinkglish.com stg-account-service-i && cli53 rrcreate -x 60 thinkglish.com  stg-account-service-i A $STG_AS_SLAVE
        if [ $? -eq 0 ]
                then
                        echo $MSG_CNAME_MODIFIED >> $LOG_FILE
                else
                        echo $MSG_CNAME_NOT_MODIFIED >> $LOG_FILE && exit 1
        fi
}


function restart_tomcat7_locally {
        MSG_APP_RUNNING_ON_SLAVE="`date`: AS is successfully running on $STG_AS_SLAVE"
        MSG_APP_NOT_RUNNING_ON_SLAVE="`date`: AS is not running in $STG_AS_SLAVE, please check"
	MSG_RESTARTING_TOMCAT="`date`: Waiting for Tomcat7 on $STG_AS_SLAVE to be restarted"

        service tomcat7 restart && echo $MSG_RESTARTING_TOMCAT >> $LOG_FILE
	sleep 120 
        curl --head --max-time 10  http://tolkien:thejohn@$STG_AS_SLAVE:8080/account_service/static/restapi.html | grep -e "200 OK"
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
        AS_MASTER_SG_ID=sg-e24ba08d
        AS_MASTER_INSTANCE_ID=i-749d493b
        MSG_SG_NOT_APPLIED_ON_MASTER="`date`: SG $AS_MASTER_SG_ID could not be applied on $STG_AS_MASTER, please verify"

        MSG_SG_APPLIED_ON_MASTER="`date`: SG $AS_MASTER_SG_ID was successfully applied on $STG_AS_MASTER"

        /opt/ec2/bin/ec2-modify-instance-attribute --group-id $AS_MASTER_SG_ID $AS_MASTER_INSTANCE_ID --debug  &> $LOG_FILE
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

