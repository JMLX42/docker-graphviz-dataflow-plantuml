FROM ubuntu:16.04
MAINTAINER Jean-Marc Le Roux <jeanmarc.leroux@gmail.com>

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y make && \
    apt-get install -y graphviz && \
    apt-get install -y haskell-platform

ENV LANG C.UTF-8
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

RUN apt-get remove -y git && \
    apt-get autoremove -y

WORKDIR /root
