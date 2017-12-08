build:
	docker build -t training/ansible:nginx -f nginx/Dockerfile.nginx .
       

build-mysql:
	docker build -t training/ansible:mysql -f mysql/Dockerfile.mysql .

build-tomcat:
	docker build -t training/ansible:tomcat -f tomcat/Dockerfile.tomcat .

build-jenkins:
	docker build -t training/ansible:jenkins -f jenkins/Dockerfile .

build-nexus:	
	docker build -t training/ansible:nexus -f nexus/Dockerfile.nexus .

	
build-all:
	make build
	make build-mysql
	make build-tomcat
	make build-jenkins
	make build-nexus

run-dbserver:
	docker rm -f dbserver || true
	docker run -h dbserver --name dbserver -e MYSQL_ROOT_PASSWORD=new -p3306:3306 -itd training/ansible:mysql

run-webapp-a:
	docker rm -f webappa || true
	docker run -h webappa --name webappa -p8080:8080 -itd training/ansible:tomcat

run-webapp-b:
	docker rm -f webappb  || true
	docker run -h webappb --name webappb -p8082:8080 -itd training/ansible:tomcat

run-nginx-1:
	docker rm -f nginx1 || true
	docker run -h nginx1 --name nginx1 -p8050:80 --link webappa:webappa --link webappb:webappb -itd training/ansible:nginx

run-nginx-2:
	docker rm -f nginx2 || true
	docker run -h nginx12 --name nginx2 -p8052:80 --link webappa:webappa --link webappb:webappb -itd training/ansible:nginx

run-nexus-server:
	docker rm -f nexus-server  || true
	docker run -h nexus-server --name nexus-server -p8081:8081 -itd training/ansible:nexus
        
	
run-cicd:
	docker rm -f cicd  || true
	docker run -h cicd --name cicd -p80:8080 -itd training/ansible:jenkins	

run-all:
	make run-dbserver
	make run-webapp-a
	make run-webapp-b
	make run-cicd
	make run-nexus-server
	make run-nginx-1
	make run-nginx-2

start-lab:
	make build-all
	make run-all
