---
title: Getting Started
layout: default
---

# {{ page.title }}

Classifier Reborn is a fork of [cardmagic/classifier](https://github.com/cardmagic/classifier) under more active development.
The Classifier Reborn library is released under the terms of the [GNU LGPL-2.1](https://github.com/jekyll/classifier-reborn/blob/master/LICENSE).
Currently, it has [Bayesian Classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier) and [Latent Semantic Indexer (LSI)](https://en.wikipedia.org/wiki/Latent_semantic_analysis) implemented.

Here is a quick example to illustrate the usage.

```bash
$ gem install classifier-reborn
$ irb
irb(main):001:0> require 'classifier-reborn'
irb(main):002:0> classifier = ClassifierReborn::Bayes.new 'Ham', 'Spam'
irb(main):003:0> classifier.train "Ham", "Sunday is a holiday. Say no to work on Sunday!"
irb(main):004:0> classifier.train "Spam", "You are the lucky winner! Claim your holiday prize."
irb(main):005:0> classifier.classify "What's the plan for Sunday?"
#=> "Ham"
```

Here is a line-by-line explanation of what we just did.

* Installed the `classifier-reborn` gem (assuming that [Ruby](https://www.ruby-lang.org/en/) is installed already).
* Started the Interactive Ruby Shell (IRB).
* Loaded the `classifier-reborn` gem in the interactive Ruby session.
* Created an instance of `Bayesian` classifier with two classes `Ham` and `Spam`.
* Trained the classifier with an example of `Ham`.
* Trained the classifier with an example of `Spam`.
* Asked the classifier to classify a text and got the response as `Ham`.

## Installation

To use `classifier-reborn` in your Ruby application add the following line into your application's `Gemfile`.

```ruby
gem 'classifier-reborn'
```

Then from your application's folder run the following command to install the gem and its dependencies.

```bash
$ bundle install
```

Alternatively, run the following command to manually install the gem.

```bash
$ gem install classifier-reborn
```

## Dependencies

The only runtime dependency of this gem is Roman Shterenzon's `fast-stemmer` gem. This should install automatically with RubyGems. Otherwise manually install it as following.

```bash
gem install fast-stemmer
```

In addition, it is **recommended** to install either Numo or GSL to speed up LSI classification by at least 10x.

Note that LSI will work without these libraries, but as soon as they are installed, classifier will make use of them. No configuration changes are needed, we like to keep things ridiculously easy for you.

### Install Numo Gems

[Numo](https://ruby-numo.github.io/narray/) is a set of Numerical Module gems for Ruby that provide a Ruby interface to [LAPACK](http://www.netlib.org/lapack/). If classifier detects that the required Numo gems are installed, it will make use of them to perform LSI faster. 

* Install [LAPACKE](https://www.netlib.org/lapack/lapacke.html)
  * Ubuntu: `apt-get install liblapacke-dev`
  * macOS: (Help wanted to verify installation steps) https://stackoverflow.com/questions/38114201/installing-lapack-and-blas-libraries-for-c-on-mac-os
* Install [OpenBLAS](https://www.openblas.net/)
  * Ubuntu: `apt-get install libopenblas-dev`
  * macOS: (Help wanted to verify installation steps) https://stackoverflow.com/questions/38114201/installing-lapack-and-blas-libraries-for-c-on-mac-os
* Install the [Numo::NArray](https://ruby-numo.github.io/narray/) and [Numo::Linalg](https://ruby-numo.github.io/linalg/) gems
  * `gem install numo-narray numo-linalg`

### Install GSL Gem

**Note:** The `gsl` gem is currently incompatible with Ruby 3. It is recommended to use Numo instead with Ruby 3.

The [GNU Scientific Library (GSL)](http://www.gnu.org/software/gsl) is an alternative to Numo/LAPACK that can be used to improve LSI performance. (You should install one or the other, but both are not required.)

* Install the [GNU Scientific Library](http://www.gnu.org/software/gsl)
  * Ubuntu: `apt-get install libgsl-dev`
* Install the [Ruby/GSL Gem](https://rubygems.org/gems/gsl) (or add it to your Gemfile)
  * `gem install gsl`


## Further Readings

For more information read the following documentation topics.

* [Bayesian Classifier](bayes)
* [Latent Semantic Indexer (LSI)](lsi)
* [Classifier Validation](validation)
* [Development and Contributions](development)
