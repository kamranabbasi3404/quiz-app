# Multi-stage Dockerfile for Quiz Application

# Stage 1: Build stage
FROM maven:3.9-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Runtime stage
FROM eclipse-temurin:17-jre

# Set working directory
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/quiz-application-1.0-SNAPSHOT.jar app.jar

# Set environment variables for database connection
ENV DB_HOST=mysql-db \
    DB_PORT=3306 \
    DB_NAME=quizapp \
    DB_USER=root \
    DB_PASSWORD=rootpassword

# Expose port if needed (for future web interface)
EXPOSE 8080

# Run the application
# Note: For GUI applications, you may need X11 forwarding or VNC
ENTRYPOINT ["java", "-jar", "app.jar"]
