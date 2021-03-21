php:
	kubectl apply -f php.yaml

phpdel:
	kubectl delete -f php.yaml

nginx:
	kubectl apply -f nginx.yaml

nginxdel:
	kubectl delete -f nginx.yaml

db:
	kubectl apply -f db.yaml

dbdel:
	kubectl delete -f db.yaml

ingress: 
	kubectl apply -f ingress.yaml

ingressdel: 
	kubectl delete -f ingress.yaml

pv:
	kubectl apply -f fpm-pv.yaml -f project-pv.yaml -f db-pv.yaml

pvdel:
	kubectl delete -f fpm-pv.yaml -f project-pv.yaml -f db-pv.yaml

helm: 
	helm install ingress stable/nginx-ingress 

unhelm:
	helm uninstall ingress

up:
	@make helm
	@make pv
	@make php
	@make nginx
	@make db
	@make ingress

del:
	@make phpdel
	@make nginxdel
	@make dbdel
	@make ingressdel
	@make pvdel
	@make unhelm


# composer:
# 	@make exec | composer update -> .env -> key:generate -> migrate

lb:
	echo "load balancer name is"
	kubectl get svc ingress-nginx-ingress-controller | awk '{print $$4}' | tail -1

exec:
	kubectl exec -it $$(kubectl get pod | grep php | awk '{print $$1}') /bin/bash

db-exec:
	kubectl exec -it $$(kubectl get pod | grep db | awk '{print $$1}') -- /bin/bash -c 'mysql -u$$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'