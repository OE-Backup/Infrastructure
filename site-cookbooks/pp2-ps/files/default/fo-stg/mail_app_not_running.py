#!/usr/bin/python
import smtplib

def prompt(prompt):
    return raw_input(prompt).strip()

fromaddr = 'noreply@openenglish.com'
toaddrs  = 'alert.stage@openenglish.com'
msg = """From: noreply@openenglish.com
To: alert.stage@openenglish.com
Subject: [STG] Payment Service app: http://tolkien:thejohn@stg-payment-service-i.thinkglish.com:8080/payment_service/static/restapi.html not reachable, please check it . 

Payment Service not reachable after promotion to SLAVE (10.16.1.15).
"""

print "Message length is " + repr(len(msg))

#Change according to your settings
smtp_server = 'email-smtp.us-east-1.amazonaws.com'
smtp_username = 'AKIAIR24K7DNISBVFDIA'
smtp_password = 'Arq6D1+ywxpK4jY+NLvEwOQ0UbndMVZGQ7YS+6xo2dYb'
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

