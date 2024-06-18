FROM openjdk:11-jre-slim 
COPY target/demo-0.0.1-SNAPSHOT.jar /usr/app/demo-0.0.1-SNAPSHOT.jar  
EXPOSE 8080
