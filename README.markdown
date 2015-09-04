## Welcome to Classifier Reborn

Classifier is a general module to allow Bayesian and other types of classifications.

Classifier Reborn is a fork of cardmagic/classifier under more active development.

## Download

Add this line to your application's Gemfile:

    gem 'classifier-reborn'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install classifier-reborn

## Dependencies

The only runtime dependency you'll need to install is Roman Shterenzon's fast-stemmer gem:

    gem install fast-stemmer

This should install automatically with RubyGems.

If you would like to speed up LSI classification by at least 10x, please install the following libraries:

* [GNU GSL](http://www.gnu.org/software/gsl)
* [rb-gsl](https://rubygems.org/gems/rb-gsl)

Notice that LSI will work without these libraries, but as soon as they are installed, Classifier will make use of them. No configuration changes are needed, we like to keep things ridiculously easy for you.

## Bayes

A Bayesian classifier by Lucas Carlson. Bayesian Classifiers are accurate, fast, and have modest memory requirements.

### Usage

```ruby
require 'classifier-reborn'
classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting'
classifier.train_interesting "here are some good words. I hope you love them"
classifier.train_uninteresting "here are some bad words, I hate you"
classifier.classify "I hate bad words and you" # returns 'Uninteresting'

classifier_snapshot = Marshal.dump classifier
# This is a string of bytes, you can persist it anywhere you like

File.open("classifier.dat", "w") {|f| f.write(classifier_snapshot) }
# Or Redis.current.save "classifier", classifier_snapshot

# This is now saved to a file, and you can safely restart the application
data = File.read("classifier.dat")
# Or data = Redis.current.get "classifier"
trained_classifier = Marshal.load data
trained_classifier.classify "I love" # returns 'Interesting'
```

Beyond the basic example, the constructor and trainer can be used in a more
flexible way to accomidate non-trival applications.  Consider the following
program:

```ruby
#!/usr/bin/env ruby
# classifier_reborn_demo.rb

require 'classifier-reborn'

training_set = DATA.read.split("\n")
categories   = training_set.shift.split(',').map{|c| c.strip}

classifier = ClassifierReborn::Bayes.new categories

training_set.each do |a_line|
  next if a_line.empty? || '#' == a_line.strip[0]
  parts = a_line.strip.split(':')
  classifier.train(parts.first, parts.last)
end

puts classifier.classify "I hate bad words and you" #=> 'Uninteresting'
puts classifier.classify "I hate javascript" #=> 'Uninteresting'
puts classifier.classify "javascript is bad" #=> 'Uninteresting'

puts classifier.classify "all you need is ruby" #=> 'Interesting'
puts classifier.classify "i love ruby" #=> 'Interesting'
puts classifier.classify "i love ruby" #=> 'Interesting'

puts classifier.classify "which is better dogs or cats" #=> 'dog'
puts classifier.classify "what do I need to kill rats and mice" #=> 'cat'

__END__
Interesting, Uninteresting
interesting: here are some good words. I hope you love them
interesting: all you need is love
interesting: the love boat, soon we will bre taking another ride
interesting: ruby don't take your love to town

uninteresting: here are some bad words, I hate you
uninteresting: bad bad leroy brown badest man in the darn town
uninteresting: the good the bad and the ugly
uninteresting: java, javascript, css front-end html
#
# train categories that were not pre-described
#
dog: dog days of summer
dog: a man's best friend is his dog
dog: a good hunting dog is a fine thing
dog: man my dogs are tired
dog: dogs are better than cats in soooo many ways

cat: the fuzz ball spilt the milk
cat: got rats or mice get a cat to kill them
cat: cats never come when you call them
cat: That dang cat keeps scratching the furniture
```

### Bayesian Classification

* http://www.process.com/precisemail/bayesian_filtering.htm
* http://en.wikipedia.org/wiki/Bayesian_filtering
* http://www.paulgraham.com/spam.html

## LSI

A Latent Semantic Indexer by David Fayram. Latent Semantic Indexing engines
are not as fast or as small as Bayesian classifiers, but are more flexible, providing
fast search and clustering detection as well as semantic analysis of the text that
theoretically simulates human learning.

### Usage

```ruby
require 'classifier-reborn'
lsi = ClassifierReborn::LSI.new
strings = [ ["This text deals with dogs. Dogs.", :dog],
            ["This text involves dogs too. Dogs! ", :dog],
            ["This text revolves around cats. Cats.", :cat],
            ["This text also involves cats. Cats!", :cat],
            ["This text involves birds. Birds.",:bird ]]
strings.each {|x| lsi.add_item x.first, x.last}

lsi.search("dog", 3)
# returns => ["This text deals with dogs. Dogs.", "This text involves dogs too. Dogs! ",
#             "This text also involves cats. Cats!"]

lsi.find_related(strings[2], 2)
# returns => ["This text revolves around cats. Cats.", "This text also involves cats. Cats!"]

lsi.classify "This text is also about dogs!"
# returns => :dog
```

Please see the ClassifierReborn::LSI documentation for more information. It is possible to index, search and classify
with more than just simple strings.

### Latent Semantic Indexing

* http://www.c2.com/cgi/wiki?LatentSemanticIndexing
* http://www.chadfowler.com/index.cgi/Computing/LatentSemanticIndexing.rdoc
* http://en.wikipedia.org/wiki/Latent_semantic_analysis

## Authors

* Lucas Carlson  (lucas@rufy.com)
* David Fayram II (dfayram@gmail.com)
* Cameron McBride (cameron.mcbride@gmail.com)
* Ivan Acosta-Rubio (ivan@softwarecriollo.com)
* Parker Moore (email@byparker.com)

This library is released under the terms of the GNU LGPL. See LICENSE for more details.
