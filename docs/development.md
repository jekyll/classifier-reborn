---
title: Development and Contributions | Classifier Reborn
layout: default
---

# Development and Contributions

This library is released under the terms of the [LGPL-2.1](https://github.com/jekyll/classifier-reborn/blob/master/LICENSE).
Any derivative work or usage of the library needs to be compatible with LGPL-2.1 or write to the author to ask for permission.
See LICENSE text for more details.

## Code of Conduct

In order to have a more open and welcoming community, `Classifier Reborn` adheres to the `Jekyll`
[code of conduct](https://github.com/jekyll/jekyll/blob/master/CONDUCT.markdown) adapted from the `Ruby on Rails` code of conduct.

Please adhere to this code of conduct in any interactions you have in the `Classifier` community.
If you encounter someone violating these terms, please let [Chase Gilliam](https://github.com/Ch4s3) know and we will address it as soon as possible.

## Development Environment

To make changes in the gem locally clone the repository or your fork.

```bash
$ git clone git@github.com:jekyll/classifier-reborn.git
$ cd classifier-reborn
$ bundle install
$ gem install redis
$ rake                       # To run tests
```

Some tests should be skipped if the Redis server is not running on the development machine.
To test all the test cases first [install Redis](https://redis.io/topics/quickstart) then run the server and perform tests.

```bash
$ redis-server --daemonize yes
$ rake                       # To run tests
$ rake bench                 # To run benchmarks
```

Kill the `redis-server` daemon when done.

## Development Using Docker

Provided that [Docker](https://docs.docker.com/engine/installation/) is installed on the development machine, clone the repository or your fork.
From the directory of the local clone build a Docker image locally to setup the environment loaded with all the dependencies.

```bash
$ git clone git@github.com:jekyll/classifier-reborn.git
$ cd classifier-reborn
$ docker build -t classifier-reborn .
```

To run tests on the local code (before or after any changes) mount the current working directory inside the container at `/usr/src/app` and run the container without any arguments.
This step should be repeated each time a change in the code is made and a test is desired.

```bash
$ docker run --rm -it -v "$PWD":/usr/src/app classifier-reborn
```

A rebuild of the image would be needed only if the `Gemfile` or other dependencies change.
To run tasks other than test or to run other commands access the Bash prompt of the container.

```bash
$ docker run --rm -it -v "$PWD":/usr/src/app classifier-reborn bash
root@[container-id]:/usr/src/app# redis-server --daemonize yes
root@[container-id]:/usr/src/app# rake                       # To run tests
root@[container-id]:/usr/src/app# rake bench                 # To run benchmarks
root@[container-id]:/usr/src/app# pry
[1] pry(main)> require 'classifier-reborn'
[2] pry(main)> classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting'
```

## Documentation

To make changes to this documentation and to run it locally, run a Docker container with the following command.

```bash
$ docker run --rm -it -v "$PWD":/usr/src/app -w /usr/src/app/docs -p 4000:4000 classifier-reborn jekyll s -H 0.0.0.0
```

If the server runs as expected then the documentation should be available at [http://localhost:4000/](http://localhost:4000/).

## Authors and Contributors

* [Lucas Carlson](mailto:lucas@rufy.com)
* [David Fayram II](mailto:dfayram@gmail.com)
* [Cameron McBride](mailto:cameron.mcbride@gmail.com)
* [Ivan Acosta-Rubio](mailto:ivan@softwarecriollo.com)
* [Parker Moore](mailto:email@byparker.com)
* [Chase Gilliam](mailto:chase.gilliam@gmail.com)
* and [many more](https://github.com/jekyll/classifier-reborn/graphs/contributors)...
