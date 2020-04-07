docker cp nifi-conf/flow.xml.gz $(docker-compose ps -q nifi):/opt/nifi/nifi-current/conf
docker-compose exec nifi mkdir /opt/nifi/nifi-current/drivers
docker cp drivers/postgresql-42.2.6.jar $(docker-compose ps -q nifi):/opt/nifi/nifi-current/drivers
docker cp zeppelin-conf/2EZMATNCU/ $(docker-compose ps -q zeppelin):/zeppelin/notebook
docker cp zeppelin-conf/interpreter.json $(docker-compose ps -q zeppelin):/zeppelin/conf
