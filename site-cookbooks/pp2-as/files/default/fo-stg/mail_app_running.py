#!/usr/bin/python
import smtplib

def prompt(prompt):
    return raw_input(prompt).strip()

fromaddr = 'noreply@openenglish.com'
toaddrs  = 'alert.stage@openenglish.com'
msg = """From: noreply@openenglish.com
To: alert.stage@openenglish.com
Subject: [STG] Account Service app is UP in slave (10.16.1.12) . 

Account Service is UP after promotion to SLAVE (10.16.1.12).
Check it out going to: http://tolkien:thejohn@stg-account-service-i.thinkglish.com:8080/account_service/static/restapi.html
"""

print "Message length is " + repr(len(msg))

#Change according to your settings
smtp_server = 'email-smtp.us-east-1.amazonaws.com'
smtp_username = 'AKIAIR24K7DNISBVFDIA'
smtp_password = 'Apy+o8s5eDvKXjtFsNjTL/OCeKP+4gCMUQBRr0CRLX8z'
smtp_port = '587'
#smtp_port = '25'
smtp_do_tls = True

server = smtplib.SMTP(
    host = smtp_server,
    port = smtp_port,
    #timeout = 10  # A Python 2.4 no le gusta esto...
)
server.set_debuglevel(10)
server.starttls()
server.ehlo()
server.login(smtp_username, smtp_password)
server.sendmail(fromaddr, toaddrs, msg)
print server.quit()

