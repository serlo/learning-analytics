Proof of concept for implementing learning analytics for serlo.org.

* [Architecture](./LA-Architektur.png)

## Deployment

1. Go to `./container/learning-analytics` and run `docker-compose up`.
2. Run  [`after-docker-compose.sh`](./container/learning-analytics/after-docker-compose.sh) afterwards (which does some of the below steps)

### RabbitMQ-Konfiguration (localhost:15672)

- Login: guest/guest
- Add Queue: learning_analytics

### nifi-Konfiguration (localhost:8080):

A) Konfigurationsdatei übernehmen (Mit [`after-docker-compose.sh`](./container/learning-analytics/after-docker-compose.sh) kann es durchgeführt werden)

- von `HOST:container/learning-analytics/nifi-conf/flow.xml.gz` nach `CONTAINER:/opt/nifi/nifi-current/conf` und von `HOST:container/learning-analytics/drivers` nach `CONTAINER:/opt/nifi/nifi-current/drivers`

B) Manuell importieren von `HOST:container/learning-analytics/nifi-conf/Postgres_Flow.xml`

Achtung: Das Passwort für die JDBC/Postgres Connection wurde beim Import nicht übernommen. Dieses muss manuell gesetzt werden.

### Postgres-Konfiguration

```
psql -d postgres
> CREATE DATABASE nifi;
> \c nifi;
> CREATE TABLE flow_files (
    uuid VARCHAR(255) PRIMARY KEY,
    filename VARCHAR(255),
    datetime TIMESTAMP NOT NULL,
    raw JSON,
    actor VARCHAR(255),
    verb VARCHAR(255),
    object VARCHAR(255),
    context VARCHAR(255)
  );
```

### Zeppelin-Konfiguration (localhost:8090)

- Copy Interpreter von `HOST:container/learning-analytics/zeppelin-conf/interpreter.json` (relevant ist darin eigentlich nur „nifi”) nach `CONTAINER:/zeppelin/conf`
- Notebooks
    - Über Github synchronisieren: Github Access Key hinterlegen (siehe https://zeppelin.apache.org/docs/0.8.0/setup/operation/configuration.html#create-github-access-token) in `HOST:container/learning-analytics/zeppelin-conf/zeppelin-env.sh` Setting:`ZEPPELIN_NOTEBOOK_GIT_REMOTE_ACCESS_TOKEN`
    - Konfigurationsdatei übernehmen von `HOST:container/learning-analytics/zeppelin-conf/zeppelin-env.sh` 	    	nach `CONTAINER:/zeppelin/conf`
    - Über REST-API anlegen
    - Neue Note: https://zeppelin.apache.org/docs/0.7.0/rest-api/rest-notebook.html#create-a-new-note
    - Neuen Paragraph: https://zeppelin.apache.org/docs/0.7.0/rest-api/rest-notebook.html#create-a-new-paragraph
- Konfigurationsdatei übernehmen von `HOST:container/learning-analytics/zeppelin-conf/2EZMATNCU` nach `CONTAINER:/zeppelin/notebook/`

### Beispiel für Abfrage:

```
curl -X POST \
  http://localhost:8090/api/notebook/run/2EZMATNCU/20200109-205741_1474479729 \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 0995608a-e851-441f-9af2-035e2817b2ee' \
  -H 'cache-control: no-cache' \
  -d '{
	"params": {
		"user_id": "1"
	}
}'
```
