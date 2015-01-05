lp2-lcs Cookbook
===============

Requirements
------------

  * OE tomcat
  * OE SSL

## Attributes

An example of attributes required:

```json
"ssl": {
  "type": "keystore",
  "fqdn": "thinkglish.com",
  "databag": "ssl",
  "databag_enc": "ssl-keys"
},

"oe-logs": {
  "logrotate": {
    "prefix": "/etc/logrotate.d"
  },

  "services": {
    "tomcat": {
        
      "log": {
        "prefix": "/mnt/log/tomcat7",
        "symlink": "/var/log/tomcat7",
        "owner": "tomcat",
        "group": "lp2"
      },
      "logrotate" => {
        "logfile": "/var/log/tomcat7/*.log",
        "interval": "daily",
        "rotate_count": "10",
        "owner": "tomcat7",
        "group": "lp2"
      }
    }
  }
}
```

Contributing
------------

`git clone <repo>`, wave your magic ruby wand and commit. 

License and Authors
-------------------
Authors:
  * Emiliano Castagnari

