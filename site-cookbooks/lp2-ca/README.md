lp2-ca Cookbook
===============

Requirements
------------

  * Opscode apache
  * OE tomcat
  * OE SSL

Attributes
----------

An example of attributes required:

```json
apache: {
  "dir": "gc/etc/apache2",
  "vhosts": [ 
    "00-lp2-ca",
    "00-lp2-ca-ssl"
  ],
  "location_aliases": [
    { 
      "location": "/css",
      "path": "/opt/open_english/webapps/ROOT/css"
    },
    { 
      "location": "/js",
      "path": "/opt/open_english/webapps/ROOT/js"
    }
  ]
},

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

