FROM ruby:3.1

ENV LANG C.UTF-8

RUN apt update && apt install -y liblapacke-dev libopenblas-dev && rm -rf /var/lib/apt/lists/*
RUN gem install numo-narray numo-linalg jekyll github-pages

RUN cd /tmp \
    && wget http://download.redis.io/redis-stable.tar.gz \
    && tar xvzf redis-stable.tar.gz \
    && cd redis-stable \
    && make && make install \
    && cd /tmp && rm -rf redis-stable*

WORKDIR /usr/src/app
COPY . /usr/src/app
RUN bundle install

CMD redis-server --daemonize yes && rake
