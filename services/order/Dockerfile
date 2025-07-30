# Použij oficiální JDK jako základní obraz
FROM eclipse-temurin:17-jdk-jammy

# Vytvoř pracovní adresář
WORKDIR /app

# Zkopíruj JAR aplikace (předpokládáme že sestavíš pomocí Maven nebo Gradle)
COPY target/order-0.1.1.jar app.jar

# Spusť aplikaci
ENTRYPOINT ["java", "-jar", "app.jar"]
