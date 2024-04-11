# Ubuntu + Ruby + NodeJS

This is a small, Ubuntu-based docker image with the latest ruby, the latest LTS nodejs version, and yarn. Mostly built for our own purposes at [Capital Factory](https://capitalfactory.com), but probably useful for more folks running Rails applications with Webpack.

### Example Dockerfile

Here is an example `Dockerfile` using this docker image, from one of my codebases:

```Dockerfile
FROM fredoliveira/ubuntu-ruby-node:latest

RUN apt update && \
    apt install -y \
    git \
    build-essential \
    postgresql \
    libpq-dev \
    mupdf \
    libmupdf-dev \
    mupdf-tools \
    libvips-dev \
    libvips-tools \
    libvips42 \
    libcurl4 \
    inotify-tools

# Install bundler
RUN gem install bundler

# Create a directory for our application
# and set it as the working directory
WORKDIR /pitch

# Install the necessary gems
COPY Gemfile* ./
RUN bundle install

# Install yarn packages
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Now that dependencies are installed, change to app folder and copy other files
COPY . .

# Compile assets
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY
ENV RAILS_ENV=$RAILS_ENV
RUN rails assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

### Building a new version

Set up a new Docker builder for multiple platform support:

```bash
docker buildx create --name mybuilder --bootstrap --use
```

Build and push a new version:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t fredoliveira/ubuntu-ruby-node:latest --push .
```
