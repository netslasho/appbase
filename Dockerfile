# Slasho.net
#
# VERSION              1.0.0
#
#LABEL maintainer="Selvaraj Mani, Krishna Veni (selvaraj@tiltedio.com, krishnaveni@tiltedio.com)" Description="Application base image" Vendor="Slasho.net" Version="1.0"

#use the ubuntu distro
FROM tomcat:alpine

#Environment to enable the startup debugging
ENV net_slasho_app_debug_startup n

ENV net_slasho_app_args ""

ENV net_slasho_app_opts "$CATALINA_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,address=8500,server=y,suspend=\$net_slasho_app_debug_startup \$net_slasho_app_args"

#copy the tomcat-users.xml so that we can have access to the manager-ui with tomcat/s3cret
ADD tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml 

ADD server.xml /usr/local/tomcat/conf/server.xml

#Copy the context.xml to the manager webapp
ADD manager-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

#copy web.xml to the manager webapp to increase the file upload size for deploy
ADD manager-web.xml /usr/local/tomcat/webapps/manager/WEB-INF/web.xml

RUN mkdir /opt/slashoapp && mv /usr/local/tomcat/webapps/manager /opt/slashoapp/manager

WORKDIR /opt/slashoapp

#ENTRYPOINT ["/usr/local/tomcat/bin/catalina.sh", "run"]
CMD CATALINA_OPTS=$net_slasho_app_opts /usr/local/tomcat/bin/catalina.sh run
