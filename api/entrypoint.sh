#!/bin/sh
exec java -javaagent:newrelic.jar -Dnewrelic.environment=${ENVIRONMENT} -jar ${APP_HOME}/boot.jar
