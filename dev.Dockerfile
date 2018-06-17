# 1: Use ruby 2.5.1 as base:
FROM ruby:2.5.1

# install dependencies
RUN apt-get update -qq && apt-get install -y build-essential nodejs chrpath libssl-dev libxft-dev \
  libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 less vim \
  curl zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev \
  libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn unzip

# Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable

# Chromedriver
RUN wget -q https://chromedriver.storage.googleapis.com/2.39/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/local/bin
RUN rm -f chromedriver_linux64.zip

# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
ARG id_rsa
RUN echo "$id_rsa" >> /root/.ssh/id_rsa
RUN chmod 0400 /root/.ssh/id_rsa

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Add bitbuckets key
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

ENV APP_HOME /app

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

## User setup
RUN set -uex && adduser --disabled-password --gecos '' rubyapp && chown rubyapp $APP_HOME

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

# Gem setup
RUN bundle install --jobs 3

# Copy the app code
COPY . $APP_HOME
