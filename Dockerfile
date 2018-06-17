# 1: Use ruby 2.5.1 as base:
FROM ruby:2.5.1

# Setup environment variables that will be available to the instance
ENV APP_HOME /app

# Installation of dependencies
RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
    nodejs \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permission
ARG id_rsa
RUN echo "$id_rsa" >> /root/.ssh/id_rsa
RUN chmod 0400 /root/.ssh/id_rsa

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Add bitbuckets key
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Create a directory for our application
# and set it as the working directory
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Add our Gemfile
# and install gems

ADD Gemfile* $APP_HOME/
RUN bundle config --global frozen 1
RUN bundle install --without development test

# Copy over our application code
ADD . $APP_HOME

# Compile assets
RUN bundle exec rake assets:clean RAILS_ENV=production COMPILE_ASSETS=true
RUN bundle exec rake assets:precompile RAILS_ENV=production COMPILE_ASSETS=true
