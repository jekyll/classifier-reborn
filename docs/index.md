---
title: Getting Started | Classifier Reborn
layout: default
---

# Getting Started

Classifier Reborn is a fork of [cardmagic/classifier](https://github.com/cardmagic/classifier) under more active development.
The library is released under the [LGPL-2.1](https://github.com/jekyll/classifier-reborn/blob/master/LICENSE).
Currently, it has [Bayesian](https://en.wikipedia.org/wiki/Naive_Bayes_classifier) and [Latent Semantic Indexer (LSI)](https://en.wikipedia.org/wiki/Latent_semantic_analysis) classifiers implemented.

Here is a quick example to illustrate the usage.

```bash
$ gem install classifier-reborn
$ irb
irb(main):001:0> require 'classifier-reborn'
irb(main):002:0> classifier = ClassifierReborn::Bayes.new 'Ham', 'Spam'
irb(main):003:0> classifier.train_ham "Sunday is a holiday. Say no to work on Sunday!"
irb(main):004:0> classifier.train_spam "You are the lucky winner! Claim your holiday prize."
irb(main):005:0> classifier.classify "What's the plan for Sunday?"
#=> "Ham"
```

Here is a line-by-line explaination of what we just did:

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

To speed up `LSI` classification by at least 10x consider installing following libraries.

* [GSL - GNU Scientific Library](http://www.gnu.org/software/gsl)
* [Ruby/GSL Gem](https://rubygems.org/gems/gsl)

Note that `LSI` will work without these libraries, but as soon as they are installed, classifier will make use of them. No configuration changes are needed, we like to keep things ridiculously easy for you.

## Further Readings

For more information read the following documentation topics.

* [Bayesian Classifier](bayes)
* [Latent Semantic Indexer (LSI)](lsi)
* [Development and Contributions](development)
