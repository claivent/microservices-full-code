FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
RUN chmod +x ./mvnw && ./mvnw clean package -DskipTests || cat /app/build.log


FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=build /app/target/gateway-0.1.1.jar .

RUN ls -la /app

EXPOSE 8222
CMD ["java", "-jar", "gateway-0.1.1.jar"]
