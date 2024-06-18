FROM tomcat:8.5.47-jdk8-openjdk
COPY target/hello-1.0.war /usr/local/tomcat/webapps  
EXPOSE 8080
