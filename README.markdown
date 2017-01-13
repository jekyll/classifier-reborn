# Classifier Reborn

[![Gem Version](https://img.shields.io/gem/v/classifier-reborn.svg)][ruby-gems]
[![Build Status](https://img.shields.io/travis/jekyll/classifier-reborn/master.svg)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/jekyll/classifier-reborn.svg)][gemnasium]
[ruby-gems]: https://rubygems.org/gems/jekyll/classifier-reborn
[gemnasium]: https://gemnasium.com/jekyll/classifier-reborn
[travis]: https://travis-ci.org/jekyll/classifier-reborn

---

## Getting Started

Classifier Reborn is a general classifier module to allow Bayesian and other types of classifications.
It is a fork of [cardmagic/classifier](https://github.com/cardmagic/classifier) under more active development.
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

For more information read the following documentation topics.

* [Installation and Dependencies](http://jekyll.github.io/classifier-reborn/)
* [Bayesian Classifier](http://jekyll.github.io/classifier-reborn/bayes)
* [Latent Semantic Indexer (LSI)](http://jekyll.github.io/classifier-reborn/lsi)
* [Development and Contributions](http://jekyll.github.io/classifier-reborn/development) (*Optional Docker instructions included*)

---

*The library is released under the [LGPL-2.1](https://github.com/jekyll/classifier-reborn/blob/master/LICENSE).*
