#!/bin/sh

service nginx stop
service mysql-server stop


service mysql-server start
service nginx start
