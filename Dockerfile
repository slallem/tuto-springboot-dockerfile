#build
FROM maven:3.6.0-jdk-11-slim as build
WORKDIR /build
#ADD http://somewhere.at.mycompany.com/mycompany-env/.m2/settings.xml settings.xml
COPY pom.xml pom.xml
#RUN mvn -s settings.xml -q dependency:go-offline
RUN mvn -q dependency:go-offline

COPY src src
#RUN mvn -s settings.xml install
RUN mvn install

#release
FROM openjdk:11.0.5-slim
COPY --from=build /build/target/*.jar my-app.jar

RUN groupadd -r my-app-group && useradd -r -g my-app-group my-app-user
USER my-app-user

ENTRYPOINT exec java -XshowSettings:vm $JAVA_OPTS -jar /my-app.jar

# To (docker-)build this example:

# $ docker build -t my-app .

# then start...

# $ docker run -P my-app

# or bind specific port (-p real-host-port:image-exposed-port)
# $ docker run -p 80:8080 my-app

# Or run it in background (-d = "detached" container)
# $ docker run -d -p 80:8080 my-app
