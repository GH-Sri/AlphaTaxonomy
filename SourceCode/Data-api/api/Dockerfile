FROM openjdk:8-jdk-alpine 
EXPOSE 8080

ARG JAR_FILE
ARG NR_JAR
ARG NR_YML
ENV ENVIRONMENT undefined

COPY entrypoint.sh entrypoint.sh
COPY  ${NR_YML}  newrelic.yml
COPY  ${NR_JAR}  newrelic.jar
COPY ${JAR_FILE} boot.jar

RUN addgroup -S morty && adduser -S -g morty morty 

RUN chown morty /entrypoint.sh

RUN chmod u+rx /entrypoint.sh \
&& chmod u+rx /*.yml \
&& chmod u+rx /*.jar

USER morty

ENTRYPOINT ["/entrypoint.sh"]
