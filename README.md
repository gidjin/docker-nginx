docker-nginx
============

Basic dockerized version of nginx what will serve files from /var/www/html/ and upload it's ip for my nginx-proxy server to read

```
/services/web/<name>/<docker hostname>
  192.168.1.2
```

The etcd updater script will need the environment variable ETCD set so it can connect to etcd. ETCD=10.0.1.2:4001
