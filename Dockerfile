# Build stage: produce the WAR
FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package \
 && ls -la target \
 && cp target/*.war /app/app.war

# Runtime stage: Tomcat serving the WAR
FROM tomcat:9.0-jdk17-temurin
# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*
# Deploy your app at root context "/"
COPY --from=builder /app/app.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8081
# Tomcat image already sets CMD to "catalina.sh run"
