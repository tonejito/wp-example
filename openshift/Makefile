#!/usr/bin/make -f
SHELL=/bin/bash

API_URL=https://api.ocp4.example.com:6443
API_USER=admin
API_PASS=redmat

TIMEOUT=3m
PROJECT=wordpress-example
DEPLOYMENT_DB=mariadb
DEPLOYMENT_WP=wordpress
ENDPOINT_URL=https://${DEPLOYMENT_WP}-${PROJECT}.apps.ocp4.example.com/

all:	clear login clean deploy logs test

clear:
	@$@

login:
	oc login -u ${API_USER} -p ${API_PASS} ${API_URL}

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

test:
	sleep 10
	curl -vk#fSL '${ENDPOINT_URL}' | \
	egrep --color=auto -e '</?title>|site-description'
