#!/usr/bin/python
import smtplib

def prompt(prompt):
    return raw_input(prompt).strip()

fromaddr = 'noreply@openenglish.com'
toaddrs  = 'notifications@openenglish.com'
msg = """From: noreply@openenglish.com
To: notifications@openenglish.com
Subject: [PRD] Payment Service app is DOWN in master (10.0.2.15). 

Payment Service app will be up in 10.0.111.15 after 3 minutes.
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

