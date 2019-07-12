# TeamTalk Cloud

Experimental cloud-native TeamTalk distribution.

This repository includes:
- `Dockerfile`s for container image build of TeamTalk.
- `docker-compose.yaml` for running all TeamTalk server components on a single host.
- TODO: Kubernetes objects for deploying TeamTalk components to Kubernetes based PaaS.

## Usage
### Run TeamTalk server on a single host

Make sure you have [Docker][] and [Docker Compose][] installed.

- Take a look at the `docker-compose.yaml` file at the project root and configuration files of TeamTalk services at `config/`, then customize anything you need.
If you need to connect outside of your host, replace the IP addresses `127.0.0.1` in `loginserver.conf` and `msgserver.conf` with the IP address of your host.
- Pull the prebuilt container images:
  ```sh
  docker-compose pull
  ```
  This is an one-time setup command, but you can rerun to update your pulled images.
  If you prefer to build container images by yourself, refer to the [Container Build](#container-build) section.
- Start MySQL server and import the database schema. This is an one-time setup unless you delete the created Docker volumes.
  ```sh
  # start the db container in the background
  docker-compose up -d db
  # open a shell session to the db container
  docker-compose exec db bash
  ## in the shell session of the `db` container, import the DB schema from /vol/db/ttopen.sql.
  mysql -u teamtalk < /vol/db/ttopen.sql
  ## exit from the shell session
  exit
  ```
- Start all containers in the background:
  ```sh
  docker-compose up -d
  ```
- Check if all containers are started by running:
  ```sh
  docker-compose ps
  ```
  If everything goes fine, you should see something like this:
  ```
           Name                   Command           State           Ports         
  --------------------------------------------------------------------------------
  teamtalk-cloud_admin_1   /usr/local/bin/run-      Up      0.0.0.0:10080->8080/tc
                          httpd.sh                         p                     
  teamtalk-cloud_db-       ./db_proxy_server        Up      0.0.0.0:32781->10600/t
  proxy_1                                                   cp                    
  teamtalk-cloud_db_1      container-entrypoint     Up      0.0.0.0:32769->3306/tc
                          run-m ...                        p                     
  teamtalk-cloud_file_1    ./file_server            Up      0.0.0.0:8600->8600/tcp
                                                            , 0.0.0.0:32785->8601/
                                                            tcp                   
  teamtalk-cloud_http-     ./http_msg_server        Up      0.0.0.0:8400->8400/tcp
  msg_1                                                                           
  teamtalk-cloud_login_1   ./login_server           Up      0.0.0.0:32786->8008/tc
                                                            p, 0.0.0.0:8080->8080/
                                                            tcp, 0.0.0.0:32784->81
                                                            00/tcp                
  teamtalk-cloud_msfs_1    ./msfs                   Up      0.0.0.0:8700->8700/tcp
  teamtalk-cloud_msg_1     ./msg_server             Up      0.0.0.0:8000->8000/tcp
  teamtalk-cloud_push_1    ./push_server            Up      0.0.0.0:32783->8500/tc
                                                            p                     
  teamtalk-cloud_redis_1   container-entrypoint     Up      0.0.0.0:32771->6379/tc
                          run-redis                        p                     
  teamtalk-cloud_route_1   ./route_server           Up      0.0.0.0:32782->8200/tc
                                                            p  
  ```
  If a container is not running, try restarting it with:
  ```
  docker-compose restart $some_service
  ```
  Because service startup order is not guaranteed in the current setup, you may encounter connection issues between `msg` and `db-proxy` services.
  Try restarting the `msg` service when it happens:
  ```sh
  docker-compose restart msg
  ```

## Container Build

`Dockerfile`s and related  artifacts are located in `images/`.

### Build Locally

The simplest way to build TeamTalk container images locally is using [Docker Compose][]. Make sure you have [Docker][] and [Docker Compose][] installed. Then run:

```sh
docker-compose build
```

## Prerequisites

[Docker]: https://docs.docker.com/
[Docker Compose]: https://docs.docker.com/compose/
