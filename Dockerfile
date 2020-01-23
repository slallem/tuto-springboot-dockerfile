FROM openjdk:11.0.5-slim

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/slallem/tuto-springboot-dockerfile/raw/master/examples/demo.jar -O my-app.jar

RUN groupadd -r my-app-group && useradd -r -g my-app-group my-app-user
USER my-app-user

EXPOSE 80

ENTRYPOINT exec java -XshowSettings:vm $JAVA_OPTS -Dserver.port=80 -jar /my-app.jar

# To build and run this example:

# $ docker build -t my-app .
# then
# $ docker run -P my-app
# or
# $ docker run -p 80:80 my-app
