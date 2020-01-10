#!/usr/bin/env python
import json
import pika

rabbit_host = "localhost"
rabbit_queue = "learning_analytics"
statement = {
    "actor": {
        "mbox": "1"
    },
    "verb": {
        "id": "http://adlnet.gov/expapi/verbs/answered"
    },
    "object": {
        "id": "http://activitystrea.ms/schema/1.0/question"
    },
    "context": {
         "value": "3"
    }
}

params = pika.ConnectionParameters(host=rabbit_host)
connection = pika.BlockingConnection()
channel = connection.channel()
channel.basic_publish(exchange="", routing_key=rabbit_queue, body=json.dumps(statement))
print("Statement sent")
connection.close()