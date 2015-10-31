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

puts classifier.classify "which is better dogs or cats" #=> 'dog'
puts classifier.classify "what do I need to kill rats and mice" #=> 'cat'

__END__
Interesting, Uninteresting
interesting: here are some good words. I hope you love them
interesting: all you need is love
interesting: the love boat, soon we will be taking another ride
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

#### Knowing the Score

When you ask a bayesian classifier to classify text against a set of trained categories it does so by generating a score (as a Float) for each possible category.  The higher the score the closer the fit your text has with that category.  The category with the highest score is returned as the best matching category.

In *ClassifierReborn* the methods *classifications* and *classify_with_score* give you access to the calculated scores.  The method *classify* only returns the best matching category.

Knowing the score allows you to do some interesting things.  For example if your application is to generate tags for a blog post you could use the *classifications* method to get a hash of the categories and their scores.  You would sort on score and take only the top 3 or 4 categories as your tags for the blog post.

You could within your application establish the smallest acceptable score and only use those categories whose score is greater than or equal to your smallest acceptable score as your tags for the blog post.

But what if you only use the *classify* method?  It does not show you the score of the best category.  How do you know that the best category is really any good?

You can use the threshold.

#### Using the Threshold

Some applications can have only one category.  The application wants to know if the text being classified is of that category or not.  For example consider a list of normal free text responses to some question or maybe a URL string coming to your web application.  You know what a normal response looks like; but, you have no idea how people might mis-use the response.  So what you want to do is create a bayesian classifier that just has one category, for example 'Good' and you want to know wither your text is classified as Good or Not Good.

Or suppose you just want the ability to have multiple categories and a 'None of the Above' as a possibility.

##### Threshold

When you initialize the *ClassifierReborn::Bayes* classifier there are several options which can be set that control threshold processing.

```ruby
b = ClassifierRebor::Bayes.new(
        'good',                 # one or more categories
        enable_threshold: true, # default: false
        threshold: -10.0        # default: 0.0
      )
b.train_good 'good stuff from Dobie Gillis'
# ...
text = 'bad junk from Maynard G. Krebs'
result = b.classify text
if result.nil?
  STDERR.puts "ALERT: This is not good: #{text}"
  let_loose_the_dogs_of_war!  # method definition left to the reader
end

```

In the *classify* method when the best category for the text has a score that is either less than the established threshold or is Float::INIFINITY, a nil category is returned.  When you see a nil value returned from the *classify* method it means that none of the trained categories (regardless or how many categories were trained) has a score that is above or equal to the established threshold.

#### Other Threshold-related Convience Methods

```ruby
b.threshold            # get the current threshold
b.threshold = -10.0    # set the threshold
b.threshold_enabled?   # Boolean: is the threshold enabled?
b.threshold_disabled?  # Boolean: is the threshold disabled?
b.enable_threshold     # enables threshold processing
b.disable_threshold    # disables threshold processing
```

Using these convience methods your applications can dynamically adjust threshold processing as required.

### Bayesian Classification

* https://en.wikipedia.org/wiki/Naive_Bayes_classifier
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
* Chase Gilliam (chase.gilliam@gmail.com)

This library is released under the terms of the GNU LGPL. See LICENSE for more details.
