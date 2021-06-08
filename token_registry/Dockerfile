FROM elixir:latest

MAINTAINER Thanos Vassilakis <thanosv@gmail.com>

RUN mix local.hex --force \
  && mix archive.install --force hex phx_new 1.5.9 \
  && apt-get update \
  && curl -sL https://deb.nodesource.com/setup_12.x | bash \
  && curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --rc \
  && apt-get install -y apt-utils \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && apt-get install -y inotify-tools \
  && apt-get install -y python3-pip \
  && pip3 install -U bigchaindb-driver \
  && mix local.rebar --force

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

EXPOSE 4000

RUN mkdir assets

COPY assets/package.json assets


CMD mix deps.get && cd assets && npm install && cd .. && iex -S mix phx.server
