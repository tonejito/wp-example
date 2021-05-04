#!/usr/bin/make -f
SHELL=/bin/bash

PROJECT=wordpress-example
DEPLOYMENT_DB=mariadb
DEPLOYMENT_WP=wordpress

all:	clean deploy logs

clean:
	clear
	oc delete project/${PROJECT}
	oc get project/${PROJECT} -w

deploy:	clusterrolebinding.yaml mariadb.yaml wordpress.yaml
	oc new-project ${PROJECT}
	oc apply -f clusterrolebinding.yaml -f mariadb.yaml -f wordpress.yaml
	oc get pods -w

logs:
	oc logs deployment/${DEPLOYMENT_DB}
	oc logs deployment/${DEPLOYMENT_WP}
