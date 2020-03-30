#!/bin/bash

param_string=""

### REQUIRED

if [[ -n "${DATABASE_TYPE}" ]]; then
    param_string="$param_string -Ddb.script=${DATABASE_TYPE}"
    echo "Using provided DATABASE_TYPE=${DATABASE_TYPE}"
else
    DATABASE_TYPE="mysql"
    echo "DATABASE_TYPE is not provided used default DATABASE_TYPE=${DATABASE_TYPE=}"
    param_string="$param_string -Ddb.script=${DATABASE_TYPE} -Djpa.database=MYSQL -Djdbc.driverClassName=com.mysql.jdbc.Driver"
    echo "Using provided DATABASE_TYPE=${DATABASE_TYPE}"
fi


if [[  ${DATABASE_TYPE} == mysql ]]; then
    param_string="$param_string -Djpa.database=MYSQL -Djdbc.driverClassName=com.mysql.jdbc.Driver"
else
    param_string="$param_string -Djpa.database=POSTGRESQL -Djdbc.driverClassName=org.postgresql.Driver"
fi


if [[ -n "${DATABASE_URL}" ]]; then
    param_string="$param_string -Djdbc.url=${DATABASE_URL} -DpropFileLocation -DpropFileLocation=classpath:spring/data-access2.properties"
    echo "Using provided DATABASE_URL=${DATABASE_URL}"
else
    echo "ERROR: DATABASE_URL is not provided"
    echo "ERROR: DATABASE_URL is a required parameter, exiting startup"
    exit 1
fi

if [[ -n "${DATABASE_USERNAME}" ]]; then
    param_string="$param_string -Djdbc.username=${DATABASE_USERNAME}"
    echo "Using provided DATABASE_USERNAME=${DATABASE_USERNAME}"
else
    echo "ERROR: DATABASE_USERNAME is not provided"
    echo "ERROR: DATABASE_USERNAME is a required parameter, exiting startup"
    exit 1
fi

if [[ -n "${DATABASE_PASSWORD}" ]]; then
    param_string="$param_string -Djdbc.password=${DATABASE_PASSWORD}"
    echo "Using provided DATABASE_PASSWORD"
else
    echo "ERROR: DATABASE_PASSWORD is not provided"
    echo "ERROR: DATABASE_PASSWORD is a required parameter, exiting startup"
    exit 1
fi

echo "param_string=$param_string"
export JAVA_OPTS="$JAVA_OPTS $param_string"


$CATALINA_HOME/bin/catalina.sh run
