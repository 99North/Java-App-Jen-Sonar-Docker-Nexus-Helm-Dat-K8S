FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install


# we need jdk11 to build our artifacts
FROM openjdk:11.0
WORKDIR /app
# in pom.xml file the tag <finalName> is the .jar file name
COPY --from=build /app/target/devops-integration.jar /app
EXPOSE 9090
CMD ["java", "-jar", "devops-integration.jar"]