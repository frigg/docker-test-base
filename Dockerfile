FROM phusion/baseimage:0.9.17

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && \
  apt-get install -y build-essential software-properties-common libssl-dev && \
  apt-get install -y byobu curl git unzip vim wget libxml2-dev libxslt-dev
RUN apt-get update && apt-get -y upgrade
RUN apt-get update && \
  apt-get install -y libjpeg62 libjpeg62-dev zlib1g-dev graphicsmagick

RUN curl -sSL https://get.docker.com/ubuntu/ | sh
RUN curl https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker > /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker
VOLUME /var/lib/docker
CMD ["wrapdocker"]

RUN apt-get update && apt-get install -y postgresql postgresql-server-dev-9.3
RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private
RUN service postgresql start && su - postgres -c "createuser -s root" && service postgresql stop
COPY files/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf

# Apache
RUN apt-get update && apt-get install -y apache2 libapache2-mod-wsgi libapache2-mod-xsendfile ssl-cert poppler-utils

RUN echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list && \
  curl https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | \
  apt-key add - && \
  apt-get update && apt-get install -y rabbitmq-server

RUN apt-get update && apt-get install -y redis-server mysql-server mongodb memcached libmysqlclient-dev
RUN apt-get update && apt-get install -y libffi6 libffi-dev
RUN apt-get update && apt-get install -y python python-dev python-pip python3 python3-dev python3-pip supervisor libboost-python-dev 
RUN pip install -U pip
RUN pip3 install -U pip
RUN pip3 install -U tox virtualenv coverage

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get update && apt-get install -y maven

RUN apt-get update && apt-get install -y ruby ruby-dev ruby-bundler

RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get update && apt-get install nodejs -y

RUN wget https://dl.bintray.com/sbt/debian/sbt-0.13.6.deb && dpkg -i sbt-0.13.6.deb

RUN gem install jekyll rake html-proofer

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
