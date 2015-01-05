oe-ssl Cookbook
============

Cookbook to create (based on existing ones) general purpose certificates,
or container certificates.

Based on existing certificates as databag items, the oe-ssl::pem recipe will
create those files (cert, key, ca and chain) on the node.

If you need a PKCS12 container, using oe-ssl::pkcs12 will include the oe-ssl::pem
recipe and generate the final container.

In case you need a JKS keystore, oe-ssl::keystore will generate the required container.

Requirements
------------

  * Openssl installed
  * Keytool command, provided by some JDK / JRE

Attributes
----------

#### Required

The required attributes for the cookbook to work are:

  * node['ssl']['type']: Container type to generate (pem|pkcs12|keystore) 
  * node['ssl']['fqdn']: Certificate's domain

#### Optional / Defaults

 * node['ssl']['databag']: (ssl) Databag name containing the public certificates
 * node['ssl']['databag_enc']: (ssl-keys) Encripted databag name containing the keys
 * node['ssl'][<type>]['prefix']: (/opt/open_english/ssl) Prefix where to put files
 * node['ssl']['owner']: (root)
 * node['ssl']['group']: (root)

Usage
-----

You only need to include the @oe-ssl@ / @oe-ssl::default@ recipe, the rest can be
accomplished defining the appropiate attributes.

#### oe-ssl::default

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[oe-ssl]"
  ]
}
```

The databags containing the certificates and keys can be changed through the
node.default['ssl']['databag'] (defaults to @ssl@) and node.default['ssl']['databag_enc'] 
(defaults to @ssl-keys@).

The @node['ssl']['databag']@ databag structure should be:

```json
{
  "id": "domain_com",
  "cert":  "-----BEGIN CERTIFICATE-----\n...",
  "ca":    "-----BEGIN CERTIFICATE-----\n...",
  "chain": "-----BEGIN CERTIFICATE-----\n..."
}
```

As for the encripted one, @node['ssl']['databag_enc']@, the structure should be:

```json
{
  "id": "domain_com",
  "keystorePass": "some_hard_pass",
  "key":          "..."
}
```

Contributing
------------

Go and submit a PR

License and Authors
-------------------
License: GPLv2
Authors: Emiliano Castagnari (a.k.a Torian)
