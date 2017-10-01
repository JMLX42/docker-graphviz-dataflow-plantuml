FROM ubuntu:16.04
MAINTAINER Jean-Marc Le Roux <jeanmarc.leroux@gmail.com>

ENV PLANTUML_VERSION=1.2017.16

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y make

# Graphviz
RUN apt-get install -y graphviz

# Dataflow
RUN apt-get install -y haskell-platform
RUN git clone https://github.com/sonyxperiadev/dataflow.git /usr/local/dataflow/
WORKDIR /usr/local/dataflow/

RUN ghc-pkg unregister --force HTTP
RUN ghc-pkg unregister --force vector
RUN ghc-pkg unregister --force QuickCheck
RUN ghc-pkg unregister --force tf-random

RUN cabal update && \
    cabal sandbox init && \
    cabal install --only-dependencies && \
    cabal configure && \
    cabal install

RUN ln -s /usr/local/dataflow/.cabal-sandbox/bin/dataflow /usr/bin/dataflow

# PantUML
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
    apt-get install -y oracle-java8-installer

RUN wget "https://downloads.sourceforge.net/project/plantuml/${PLANTUML_VERSION}/plantuml.${PLANTUML_VERSION}.jar" -O /usr/lib/plantuml.jar && \
    echo "#!/bin/bash\njava -Djava.awt.headless=true -jar /usr/lib/plantuml.jar $@" > /usr/bin/plantuml && \
    chmod +x /usr/bin/plantuml

# Cleanup
RUN apt-get remove -y git software-properties-common && \
    apt-get autoremove -y

WORKDIR /root
