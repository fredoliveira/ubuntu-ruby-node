FROM ubuntu:latest

ARG RUBY_VERSION=3.2.1
ARG NODE_VERSION=16.15.1
ARG YARN_VERSION=1.22.19

RUN apt update && \
    apt install -y \
      git \
      curl \
      libssl-dev \
      libreadline-dev \
      zlib1g-dev \
      autoconf \
      bison \
      build-essential \
      libyaml-dev \
      libreadline-dev \
      libncurses5-dev \
      libffi-dev \
      libgdbm-dev \
      wget

# Work from a place we can clean up later
WORKDIR /tmp

# Install the required ruby version
ADD gemrc /root/.gemrc
RUN wget "https://github.com/rbenv/ruby-build/archive/refs/tags/v20230428.tar.gz" -O rubybuild.tar.gz && tar -xzf rubybuild.tar.gz
RUN PREFIX=/usr/local ./ruby-build-20230428/install.sh
RUN ruby-build $RUBY_VERSION /usr/local/

# Install Node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt install -y nodejs

# Install yarn
RUN apt remove cmdtest yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt install -y yarn
