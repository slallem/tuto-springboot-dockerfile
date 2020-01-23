#build
FROM maven:3.6.0-jdk-11-slim as build
WORKDIR /build
ADD http://internal-tools.gitpages.eu.lectra.com/lectra-env/.m2/settings.xml settings.xml
COPY pom.xml pom.xml
RUN mvn -s settings.xml -q dependency:go-offline

COPY src src
RUN mvn -s settings.xml install

#release
FROM openjdk:11.0.5-slim
COPY --from=build /build/target/*.jar my-app.jar

RUN groupadd -r portal-notifications-gen && useradd -r -g portal-notifications-gen portal-notifications-gen
USER portal-notifications-gen

ENTRYPOINT exec java -XshowSettings:vm $JAVA_OPTS -jar /my-app.jar
