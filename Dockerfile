FROM ubuntu:14.04

RUN apt-get update && \
  apt-get install -y build-essential software-properties-common libssl-dev && \
  apt-get install -y byobu curl git unzip vim wget
RUN apt-get update && apt-get -y upgrade
RUN apt-get update && \
  apt-get install -y libjpeg62 libjpeg62-dev zlib1g-dev

RUN apt-get update && apt-get install -y postgresql postgresql-server-dev-9.3
RUN apt-get update && apt-get install -y redis-server
RUN apt-get update && apt-get install -y python python-dev python-virtualenv python3 python3-dev supervisor libboost-python-dev 
RUN pip install -U pip
RUN pip install -U tox flake8 isort coverage

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get update && apt-get install -y maven

RUN apt-get update && apt-get install -y ruby ruby-dev ruby-bundler

RUN wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh

RUN wget https://dl.bintray.com/sbt/debian/sbt-0.13.6.deb && dpkg -i sbt-0.13.6.deb

RUN gem install jekyll