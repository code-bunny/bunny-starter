# Bunny Starter App

## Pre setup

- Install Docker for Mac/Windows/Linux

## Setup

### Build the stack

- Build the apps

```docker-compose build```

- Create the databases

```docker-compose run --rm web rake db:setup```

## Running tests

- Setup

```docker-compose run --rm web rake db:test:prepare```

- Run

```docker-compose run web bash```

- Then run your tests

```RAILS_ENV=test rails test```

- Or your system tests

```RAILS_ENV=test rails test:system```

## Running commands on the service

```docker-compose exec web bash```

## Starting the server

```docker-compose up```

## Binding.pry

To run binding.pry via docker you need to run the individual service as so
```docker-compose run --service-ports web```

## Oh crap something on docker broke, can't bind ports, meh!

```docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)```
