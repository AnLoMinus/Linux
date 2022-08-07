#!/bin/sh

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-x86_64.rpm
sudo rpm -vi filebeat-6.5.4-x86_64.rpm

cp filebeat.yml /etc/filebeat/

filebeat setup --dashboards
service filebeat start