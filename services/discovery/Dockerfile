### Dockerfile (pro slozku discovery-service)
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN chmod +x ./mvnw && ./mvnw package -DskipTests

EXPOSE 8761

CMD ["java", "-jar", "target/discovery-0.1.1.jar"]
