# Ergast API running on NGINX Unit
This is a fork of the ergast-f1-api project. It has been modified to run on NGINX Unit within a single container.
The default output format has also been changed to JSON.

# ergast Local API Server

Based on the [`ergast-f1-api`](https://github.com/jcnewell/ergast-f1-api), a PHP-based API using the [Ergast Formula One MySQL database](http://ergast.com/mrd/) developed by Chris Newell.

## Instructions for building docker container

- install docker
- download and unzip the contents repository 
- cd into the root folder and run: `docker build -t ergastf1 .`

## Instructions for running the docker container
- run: `docker run --rm -p 80:80 --name ergastf1 ergastf1`

