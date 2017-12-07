build:
	docker build -t workshop/ansible:nginx -f nginx/Dockerfile.nginx .
       

build-mysql:
	docker build -t workshop/ansible:mysql -f mysql/Dockerfile.mysql .

build-tomcat:
	docker build -t workshop/ansible:tomcat -f tomcat/Dockerfile.tomcat .

build-jenkins:
	docker build -t workshop/ansible:jenkins -f jenkins/Dockerfile .
	
build-all:
	make build
	make build-mysql
	make build-tomcat
        make build-jenkins

run-nginx-1:
	docker rm -f nginx1 || true
	docker run -h nginx1 --name nginx1 -itd workshop/ansible:nginx

run-nginx-2:
	docker rm -f nginx2 || true
	docker run -h nginx2 --name nginx2 -itd workshop/ansible:nginx

run-dbserver:
	docker rm -f dbserver || true
	docker run -h dbserver --name dbserver -e MYSQL_ROOT_PASSWORD=new -p3306:3306 -itd workshop/ansible:mysql

run-webapp-a:
	docker rm -f webappa || true
	docker run -h webappa --name webappa -itd workshop/ansible:tomcat

run-webapp-b:
	docker rm -f webappb  || true
	docker run -h webappb --name webappb -itd workshop/ansible:tomcat
	
run-jenkins:
	docker rm -f jenkins  || true
	docker run -h jenkins --name jenkins -p80:80 -itd workshop/ansible:jenkins	

run-all:
	make run-nginx-1
	make run-nginx-2
	make run-dbserver
	make run-webapp-a
	make run-webapp-b
	make run-jenkins
       


start-lab:
	make build-all
	make run-all
