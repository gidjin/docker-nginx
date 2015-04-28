docker-nginx-proxy
==================

Basic dockerized version of nginx what will auto generate a proxy configuration for all services with configuration in etcd.

```
/services/web/<site_name>/main_domain
  www.example.com
/services/web/<site_name>/servers
  [{"ip":"192.168.1.2", "port":"80"},{"ip":"192.168.1.3","port":"80"}]
/services/web/<site_name>/aliases
  another.example.com second.example.com
```

confd is setup in the container to run ever 5 minutes and check for changes to the above noted keys. If there are changes then a new config file is generated and nginx is reloaded.

By default the container will start confd watching etcd in the background and nginx in the foreground.

The confd script will need the environment variable HOST_IP set so it can connect to etcd. If you are not running etcd on port 4001 then you should set ETCD_PORT as well.
