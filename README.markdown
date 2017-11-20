# Classifier Reborn

[![Gem Version](https://badge.fury.io/rb/classifier-reborn.svg)](https://rubygems.org/gems/classifier-reborn)
[![Build Status](https://img.shields.io/travis/jekyll/classifier-reborn/master.svg)](https://travis-ci.org/jekyll/classifier-reborn)
[![Dependency Status](https://img.shields.io/gemnasium/jekyll/classifier-reborn.svg)](https://gemnasium.com/jekyll/classifier-reborn)

---

## [Read the Docs](http://www.classifier-reborn.com/)

## Getting Started

Classifier Reborn is a general classifier module to allow Bayesian and other types of classifications.
It is a fork of [cardmagic/classifier](https://github.com/cardmagic/classifier) under more active development.
Currently, it has [Bayesian Classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier) and [Latent Semantic Indexer (LSI)](https://en.wikipedia.org/wiki/Latent_semantic_analysis) implemented.

Here is a quick illustration of the Bayesian classifier.

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

Now, let's build an LSI, classify some text, and find a cluster of related documents.

```bash
irb(main):006:0> lsi = ClassifierReborn::LSI.new
irb(main):007:0> lsi.add_item "This text deals with dogs. Dogs.", :dog
irb(main):008:0> lsi.add_item "This text involves dogs too. Dogs!", :dog
irb(main):009:0> lsi.add_item "This text revolves around cats. Cats.", :cat
irb(main):010:0> lsi.add_item "This text also involves cats. Cats!", :cat
irb(main):011:0> lsi.add_item "This text involves birds. Birds.", :bird
irb(main):012:0> lsi.classify "This text is about dogs!"
#=> :dog
irb(main):013:0> lsi.find_related("This text is around cats!", 2)
#=> ["This text revolves around cats. Cats.", "This text also involves cats. Cats!"]
```

There is much more that can be done using Bayes and LSI beyond these quick examples.
For more information read the following documentation topics.

* [Installation and Dependencies](http://www.classifier-reborn.com/)
* [Bayesian Classifier](http://www.classifier-reborn.com/bayes)
* [Latent Semantic Indexer (LSI)](http://www.classifier-reborn.com/lsi)
* [Classifier Validation](http://www.classifier-reborn.com/validation)
* [Development and Contributions](http://www.classifier-reborn.com/development) (*Optional Docker instructions included*)

### Notes on JRuby support

```ruby
gem 'classifier-reborn-jruby', platforms: :java
```

While experimental, this gem should work on JRuby without any kind of additional changes. Unfortunately, you will **not** be able to use C bindings to GNU/GSL or similar performance-enhancing native code. Additionally, we do not use `fast_stemmer`, but rather [an implementation](https://tartarus.org/martin/PorterStemmer/java.txt) of the [Porter Stemming](https://tartarus.org/martin/PorterStemmer/) algorithm. Stemming will differ between MRI and JRuby, however you may choose to [disable stemming](https://tartarus.org/martin/PorterStemmer/) and do your own manual preprocessing (or use some other [popular Java library](https://opennlp.apache.org/)). 

If you encounter a problem, please submit your issue with `[JRuby]` in the title.

## Code of Conduct

In order to have a more open and welcoming community, `Classifier Reborn` adheres to the `Jekyll`
[code of conduct](https://github.com/jekyll/jekyll/blob/master/CODE_OF_CONDUCT.markdown) adapted from the `Ruby on Rails` code of conduct.

Please adhere to this code of conduct in any interactions you have in the `Classifier` community.
If you encounter someone violating these terms, please let [Chase Gilliam](https://github.com/Ch4s3) know and we will address it as soon as possible.

## Authors and Contributors

* [Lucas Carlson](mailto:lucas@rufy.com)
* [David Fayram II](mailto:dfayram@gmail.com)
* [Cameron McBride](mailto:cameron.mcbride@gmail.com)
* [Ivan Acosta-Rubio](mailto:ivan@softwarecriollo.com)
* [Parker Moore](mailto:email@byparker.com)
* [Chase Gilliam](mailto:chase.gilliam@gmail.com)
* and [many more](https://github.com/jekyll/classifier-reborn/graphs/contributors)...

The Classifier Reborn library is released under the terms of the [GNU LGPL-2.1](https://github.com/jekyll/classifier-reborn/blob/master/LICENSE).
