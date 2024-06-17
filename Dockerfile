# Use a base image with JDK and Gradle pre-installed
FROM gradle:7.3.3-jdk11 AS builder

# Set working directory
WORKDIR /app

# Copy Gradle files for caching dependencies
COPY build.gradle .
COPY settings.gradle .
COPY gradle.properties .

# Copy the Gradle wrapper
COPY gradlew .
COPY gradle/ ./gradle/

# Download dependencies and cache them
RUN ./gradlew --no-daemon dependencies

# Copy the entire project
COPY . .

# Build application
RUN ./gradlew --no-daemon build

# Use a lighter base image for the application
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy built JAR from builder stage
COPY --from=builder /app/build/libs/*.jar ./app.jar

# Expose port
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
