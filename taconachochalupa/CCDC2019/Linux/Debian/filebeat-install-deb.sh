#!/bin/sh

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-amd64.deb
sudo dpkg -i filebeat-6.5.4-amd64.deb

cp filebeat.yml /etc/filebeat/

filebeat setup --dashboards
service filebeat start