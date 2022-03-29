#!/usr/bin/make -f
SHELL=/bin/bash

PROJECT=wordpress-example
DEPLOYMENT_DB=mariadb
DEPLOYMENT_WP=wordpress
TIMEOUT=3m

all:	clear login clean deploy logs

login:
	oc login -u admin -p redhat https://api.ocp4.example.com:6443

clear:
	@$@

clean:
	-oc delete project/${PROJECT}
	-oc get project/${PROJECT} -w

deploy:	clusterrolebinding.yaml mariadb.yaml wordpress.yaml
	oc new-project ${PROJECT}
	oc apply -f clusterrolebinding.yaml
	for APP in mariadb wordpress ; \
	do \
	  echo "$${APP}" ; \
	  oc apply -f $${APP}.yaml ; \
	  oc wait --for condition=ready pod -l app=$${APP} --timeout=${TIMEOUT} ; \
	  oc get pods ; \
	done ;

logs:
	oc logs deployment/${DEPLOYMENT_DB}
	oc logs deployment/${DEPLOYMENT_WP}
