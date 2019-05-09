# Slasho.net
#
# VERSION              1.0.0
#
#LABEL maintainer="Selvaraj Mani, Krishna Veni (selvaraj@tiltedio.com, krishnaveni@tiltedio.com)" Description="Application base image" Vendor="Slasho.net" Version="1.0"

#use the ubuntu distro
FROM ubuntu:latest

#Update the packages
RUN apt-get -y update && apt-get -y upgrade

#install the open JDK
RUN apt-get -y install openjdk-8-jdk wget vim

#create the tomcat installation dir
RUN mkdir /usr/local/tomcat

#Download the tomcat8
RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.40/bin/apache-tomcat-8.5.40.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-8.5.40/* /usr/local/tomcat/

#copy the tomcat-users.xml so that we can have access to the manager-ui with tomcat/s3cret
ADD tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml 

ADD server.xml /usr/local/tomcat/conf/server.xml

#Copy the context.xml to the manager webapp
ADD manager-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

#copy web.xml to the manager webapp to increase the file upload size for deploy
ADD manager-web.xml /usr/local/tomcat/webapps/manager/WEB-INF/web.xml

RUN mkdir -p /opt/slashoapp/manager/ && cp -r /usr/local/tomcat/webapps/manager /opt/slashoapp/

ENTRYPOINT ["/usr/local/tomcat/bin/catalina.sh", "run"]

#modify the 