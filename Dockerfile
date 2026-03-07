# Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml ./
COPY src ./src
RUN mvn -q -DskipTests package

# Runtime stage
FROM tomcat:10.1-jdk17-temurin

# Deploy WAR
COPY --from=build /app/target/university-erp.war /usr/local/tomcat/webapps/university-erp.war

EXPOSE 8080
