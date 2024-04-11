FROM ruby:3.3.0-alpine

RUN apk add --no-cache git make g++

RUN mkdir -p /app/lib/vending
WORKDIR /app

COPY Gemfile Gemfile.lock vending.gemspec /app/
COPY lib/vending/version.rb /app/lib/vending/

RUN bundle install

COPY . /app/

CMD bin/cli
