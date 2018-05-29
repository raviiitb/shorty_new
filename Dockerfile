FROM ruby:2.5.1
RUN apt-get update -qq
RUN mkdir /shorty
WORKDIR /shorty
COPY Gemfile /shorty/Gemfile
COPY Gemfile.lock /shorty/Gemfile.lock
RUN bundle install
COPY . /shorty
