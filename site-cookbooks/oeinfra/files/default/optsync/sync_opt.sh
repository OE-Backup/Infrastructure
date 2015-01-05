#! /bin/sh
### BEGIN INIT INFO
# Provides:           Keep in sync /opt with s3cmd sync /opt/ s3://infra-packages/Servers/SERVER/opt
### END INIT INFO
#
s3cmd --exclude "*chef*" --exclude "*dotcms*" sync /opt/ s3://infra-packages/Servers/$APPHOST/opt/ 
