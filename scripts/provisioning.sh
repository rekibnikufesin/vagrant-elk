#!/usr/bin/env bash

# Add repos & update
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
echo "deb http://packages.elastic.co/kibana/4.5/debian stable main" | tee -a /etc/apt/sources.list.d/kibana-4.x.list
echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | tee -a /etc/apt/sources.list.d/logstash-2.x.list

apt-get update
apt-get install curl figlet openjdk-7-jre -y
apt-get install elasticsearch
apt-get install kibana
apt-get install logstash

/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
/bin/systemctl enable kibana.service

#create the kibana.log 
touch /var/log/kibana.log
chown kibana:kibana /var/log/kibana.log

#replace configs
/bin/cp -f /vagrant/conf/kibana.yml /opt/kibana/config/kibana.yml
/bin/cp -f /vagrant/conf/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

#replace logstash config
#so this config is going to read every file, with every restart
#if that's not what you want, you should fix that
/bin/cp -f /vagrant/conf/logstash.conf /etc/logstash/conf.d/logstash.conf

#template for the index
/bin/cp -f /vagrant/conf/elb-template.json /opt/logstash/elb-template.json

#bounce them to pick up edits
/bin/systemctl restart elasticsearch
/bin/systemctl restart logstash
/bin/systemctl restart kibana

figlet "Fuck yeah!"