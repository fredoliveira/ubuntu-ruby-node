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

# Install node and yarn
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION $NODE_VERSION
RUN mkdir -p $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm use $NODE_VERSION \
    && npm install --global yarn@$YARN_VERSION
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH
