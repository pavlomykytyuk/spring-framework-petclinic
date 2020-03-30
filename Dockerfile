FROM alpine:3.9

LABEL maintainer="pavlo.mykytyuk@gmail.com"

RUN apk --update add curl ca-certificates tar zip unzip wget bash openjdk8 so:libnss3.so

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ARG TOMCAT_VERSION=8.5.53

ENV CATALINA_HOME=/opt/apache-tomcat-${TOMCAT_VERSION}
ENV PATH=$PATH:$CATALINA_HOME/bin
ARG TOMCATURL=https://downloads.apache.org/tomcat/tomcat-8/v8.5.53/bin/apache-tomcat-8.5.53.tar.gz
#http://apache.cp.if.ua/tomcat/tomcat-8/v8.5.41/bin/apache-tomcat-8.5.41.tar.gz
RUN addgroup tomcat \
    && adduser -D -G tomcat tomcat \
    && mkdir -p /opt \
    && curl ${TOMCATURL} -o /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && tar xpfz /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt \
    && rm /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && chown -R tomcat:tomcat /opt/apache-tomcat-${TOMCAT_VERSION} \
    && chown -R tomcat:tomcat $CATALINA_HOME \
    && chown -R tomcat:tomcat /home/tomcat

WORKDIR $CATALINA_HOME

COPY --chown=tomcat:tomcat target/petclinic.war $CATALINA_HOME/webapps/petclinic.war
COPY --chown=tomcat:tomcat docker_startup.sh $CATALINA_HOME/bin/docker_startup.sh
USER tomcat

RUN chmod +x $CATALINA_HOME/bin/docker_startup.sh

EXPOSE 8080

CMD  $CATALINA_HOME/bin/docker_startup.sh



