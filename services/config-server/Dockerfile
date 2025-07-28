### Dockerfile (pro slozku config-server)
FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x ./mvnw && ./mvnw package -DskipTests

EXPOSE 8888

CMD ["java", "-jar", "target/config-server-0.1.1.jar"]