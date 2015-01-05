#!/usr/bin/env python2

import re 
import pwd
import datetime

log_file = '/var/log/audit/audit.log'
current_event_id = -1

p_syscall = re.compile(r'''
    ^type=SYSCALL
    \ msg=audit\((?P<date>\d+\.\d+):
    (?P<event_id>\d+)\):.*
    auid=(?P<auid>\d+)\s+
    uid=(?P<uid>\d+)\s+
    gid=(?P<gid>\d+)\s+
    euid=(?P<euid>\d+)\s+
    suid=(?P<suid>\d+)\s+
    fsuid=(?P<fsuid>\d+)\s+
    egid=(?P<egid>\d+)\s+
    sgid=(?P<sgid>\d+)\s+
    fsgid=(?P<fsgid>\d+).*
    exe="(?P<exe>\S+)".*
    ''', re.VERBOSE)

p_execve_args = re.compile(r'''\s+(a\d+=.*)\s+''')

p_execve = re.compile(r'''
    ^type=EXECVE
    \ msg=audit\((?P<date>\d+\.\d+):
    (?P<event_id>\d+)\):.*
    ''', re.VERBOSE)

for line in reversed(open(log_file).readlines()):
    if line.startswith('type=SYSCALL'):

        m = p_syscall.match(line.strip())

        if m:
            if m.group('event_id') != current_event_id:
                if current_event_id != -1:
                    if 'args' in event.keys():
                    event['args'] = "-"
                    print "user %s(%s) as %s(%s) executed %s %s" %(event['auidname'], event['auid'], event['uidname'], event['uid'], event['exe'], event['args'])

                event = {}
                event['id'] = m.group('event_id')
                current_event_id = m.group('event_id')
            
            event['date'] = m.group('date')
            event['auid'] = m.group('auid')
            event['uid'] = m.group('uid')
            event['exe'] = m.group('exe')
            event['auidname'] = pwd.getpwuid(int(event['auid']))[0]
            event['uidname'] = pwd.getpwuid(int(event['uid']))[0]
            event['fdate'] = datetime.datetime.fromtimestamp(float(event['date'])).strftime('%Y-%m-%d %H:%M:%S')

        else:
            continue

    elif line.startswith('type=EXECVE'):
        
        m = p_execve.match(line.strip())

        if m:
            if m.group('event_id') != current_event_id:
                if current_event_id != -1:
                    print "%s user %s(%s) as %s(%s) executed %s %s" %(event['fdate'], event['auidname'], event['auid'], event['uidname'], event['uid'], event['exe'], event['args'])
                event = {}
                event['id'] = m.group('event_id')
                current_event_id = m.group('event_id')

                event['args'] = ''
                for arg in p_execve_args.findall(line):
                    event['args'] += "%s " %(arg)

        else:
            continue

