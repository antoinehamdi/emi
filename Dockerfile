FROM openjdk:12.0.1-jdk-oraclelinux7
MAINTAINER Hajar Binks
ENTRYPOINT ["/usr/bin/java", "-jar", "/tmp/myservice.war"]
# Add the service itself
ARG JAR_FILE
ADD target/${JAR_FILE} /tmp/myservice.war

