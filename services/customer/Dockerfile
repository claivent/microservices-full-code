# Dockerfile
FROM amazoncorretto:17-alpine
WORKDIR /app

# JAR vyrobí CI (mvn package); vezmeme ho z target/
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# volitelné JVM flags (nastavitelné přes -e JAVA_OPTS="...")
ENV JAVA_OPTS=""
EXPOSE 8090

ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]