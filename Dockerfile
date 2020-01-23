FROM openjdk:11.0.5-slim

RUN wget https://github.com/slallem/tuto-springboot-dockerfile/raw/master/examples/demo.jar -O my-app.jar

RUN groupadd -r my-app-group && useradd -r -g my-app-group my-app-user
USER my-app-user

ENTRYPOINT exec java -XshowSettings:vm $JAVA_OPTS -jar /my-app.jar
