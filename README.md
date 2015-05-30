docker-nginx
============

Basic dockerized version of nginx what will serve files from /var/www/html/ and upload it's ip for my nginx-proxy server to read

```
/services/web/<main_domain>/servers/<docker hostname>
  {"ip":"192.168.1.2", "port":"80"}
/services/web/<main_domain>/aliases
  another.example.com second.example.com
```

The etcd updater script will need the environment variable HOST_IP set so it can connect to etcd. If you are not running etcd on port 4001 then you should set ETCD_PORT as well.
