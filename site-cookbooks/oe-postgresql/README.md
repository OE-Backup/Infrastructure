oe-postgresql Cookbook
======================


Tested on Platforms
-------------------

  * Ubuntu precise (12.04)

Requirements
------------

  * [apt](https://github.com/opscode-cookbooks/apt)
  * [oe-logs](https://github.com/openenglish/infrastructure)

Usage
-----

You should only need to include the default recipe (and define some attributes). Features
are mainly enabled based on attributes definitions.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[oe-postgresql]"
  ]
}
```

#### Stanalone Master

To install and configure a standalone PostgreSQL server, you should only need to include
`oe-postgresql`.

FIXME: required attributes

```json
"postgresql": {
  FIXME
}
```

If you want to handle database user creation with this cookbook you need to create a `data bag`
and an *encrypted* item. The names should match the definitions of the following attributes
(can changed as a Node/Role/Environment attribute):

  * node.postgresql.data_bag (defaults to _db_)
  * node.postgresql.data_bag_item (defaults to _users_)


The data bag item structure should be:

```json
{
  "id": "users",
  "stage": {
    "db_user_1": {
      "password": "some_password"
    },
    "db_replicator": {
      "password":   "replicator_password",
      "replicator": true,
      "superuser":  true
    },
  }
}
```

The available attributes to grant privileges to the user are:

  * `superuser`:  true|false
  * `replicator`: true|false

#### Cluster Master / Slave

Master / Slave setup should be executed in order:

  1. Master node 
  2. Slave node

The obvious reason is that slave will replicate through `repmgr`, and for that, it needs the
master node.

Attributes that should be defined on the Environment/Role

```json
"postgresql": {
  "master": "master.host.name",
  "server": {
    "replication": true
  },
  "databases": [
    {
      ... # View Database Creation section
    }
  ],
  "cluster": {
    "hosts": [ "master.host.name", "slave1.host.name" ]
  },
},

"repmgr": {
  "config": {
    "cluster": "cluster_name"
  }
}
```

### Master setup

```json
"postgresql": {
  "server": {
    "type": "master"
  }
},
"repmgr": {
  "config": {
    "node": 1
  }
}
```

### Slave setup

```json
"postgresql": {
  "server": {
    "type": "slave"
  }
},
"repmgr": {
  "config": {
    "node": 2
  }
}
```

#### Cluster Master / RO

### RO setup

```json
"postgresql": {
  "server": {
    "type": "ro"
  }
},
"repmgr": {
  "config": {
    "node": 3
  }
}
```

#### Database creation

Databases are specified on a Node/Environment/Role attribute array. Each element is a hash
containing the following attributes:

  * name        *(required)*
  * owner       *(required)*
  * encoding    (optional)
  * locale      (optional)
  * tablespace  (optional)

Example:

```json
"postgresql": {
  "databases": [
    {
      "name":  "some_db_1",
      "owner": "dbowner1"
    },
    {
      "name":       "some_db_2",
      "owner":      "dbowner2",
      "encoding":   "utf8",
      "locale":     "en_us",
      "tablespace": "something"
    }
  ]
}
```

Recipes
-------
  * `oe-postgresql::default` This is the only one that you should include
  * `oe-postgresql::apt` Repository setup
  * `oe-postgresql::create_users` Database user creation
  * `oe-postgresql::create_db` Database creation
  * `oe-postgresql::sysctl` Setup sysctl parameters
  * `oe-postgresql::server` Package installation
  * `oe-postgresql::server_type` Includes recipes based on the server type
  * `oe-postgresql::server_master` Actions taken for the master, either standalone or in replication mode
  * `oe-postgresql::server_slave` Actions taken for the slave server
  * `oe-postgresql::server_ro` Actions taken for the readonly server
  * `oe-postgresql::repmgr`
  * `oe-postgresql::repmgr_master`
  * `oe-postgresql::repmgr_slave`
  * `oe-postgresql::repmgr_ro`

Attributes
----------
  TODO

TODO
----

  * Add postgres user ssh keys for `repmgr` to work on master/slave mode
  * It'd be nice to re-think some attribute names, hierarchy
  * Refactor repmgr recipes
  * Fix specs as they are broken due to `stub_command` not working
  * It'd be nice to move `create_users` and `create_db` to `definitions`

Contributing
------------
  - Opscode: Based some functionality on [opscode/postgresql](https://github.com/hw-cookbooks/postgresql)

License and Authors
-------------------
Authors: 
  - Emiliano Castagnari (emiliano.castagnari@openenglish.com)

