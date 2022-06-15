FROM ubuntu:20.04

ENV TZ=Europe/Moscow

RUN apt update -y && apt install -y nano curl htop wget &&\
    apt clean &&\
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y openjdk-8-jdk git ssh &&\
    apt clean
RUN groupadd -g 1234 jenkins &&\
    useradd -m -u 1234 -g 1234 jenkins 
RUN mkdir /run/sshd &&\
    mkdir /home/jenkins/worker
COPY jenkins.war /home/jenkins/worker/jenkins.war   
COPY apache-maven*tar.gz SenchaCmd* /tmp/

RUN chown -R jenkins:jenkins /home/jenkins && \
    tar xzfv /tmp/apache-maven*.tar.gz -C /opt/ && \
    ln -s /opt/apache-maven-3.3.9/bin/mvn /usr/bin/mvn && \
    /tmp/Sencha*.sh -q -dir  /opt/Sencha/Cmd/6.5.3.6 &&\
    rm -f /tmp/apache-maven*.tar.gz
    
COPY repo /opt/Sencha/Cmd/repo

RUN chown -R jenkins:jenkins /opt/Sencha

WORKDIR /home/jenkins/worker

USER jenkins
MAINTAINER bagda

CMD java -DJENKINS_HOME=/home/jenkins/worker -jar /home/jenkins/worker/jenkins.war 1>&- 2>&-
