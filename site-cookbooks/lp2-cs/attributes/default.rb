default['tomcat']['jars'] = {
  :add => [
    {
      :name   => 'postgresql-9.2-1002-jdbc4.jar',
      :digest => 'cd1824fa8c059e6376c92020f1e7fe6c6f34772e9f91711327e414f1b979fbe1',
      :dst    => '/usr/share/tomcat7/lib'
    },
    {
      :name   => 'catalina-jmx-remote.jar',
      :digest => '4973c02140b67e31550ddfc5fbdbd5c577888ee29153c8df0fa8430f46aade95',
      :dst    => '/usr/share/tomcat7/lib'
    }
  ]
}

