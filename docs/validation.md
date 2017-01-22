---
title: Classifier Validation
layout: default
---

# {{ page.title }}

Classifier Reborn provides with various methods to evaluate, validate, and generate statistics for classifiers.
To illustrate the usage let's walk through some examples.

For this walk through we will use the [SMSSpamCollection.tsv](https://github.com/jekyll/classifier-reborn/blob/master/test/data/corpus/SMSSpamCollection.tsv) data file that is included in the project repository.
It is a TSV file in which the first column is the class (`ham` or `spam`) and the second column is the corresponding SMS text.
Entries of this file look like below.

```tsv
ham	Yeah that's the impression I got
ham	I was slept that time.you there?
spam	Win a £1000 cash prize or a prize worth £5000
ham	Hope you are not scared!
...
```

However, the validator does not read data from files so we need to transform the data in the required format.
Also, we will only select the first 5,000 records from the file for this illustration.

```ruby
# encoding: utf-8
require 'classifier-reborn'

tsv_file_path = "test/data/corpus/SMSSpamCollection.tsv"
data = File.read(tsv_file_path).force_encoding("utf-8").split("\n")
sample_data = data.take(5000).collect { |line| line.strip.split("\t") }
```

Although, loading `classifier-reborn` is not needed just yet, but we will need it as we extend this script incrementally.
The `sample_data` is in the required format now. The following is what it looks like.

```ruby
puts sample_data.sample(4)
#=> [["ham", "Yeah that's the impression I got"],
#=>  ["ham", "I was slept that time.you there?"],
#=>  ["spam", "Win a £1000 cash prize or a prize worth £5000"],
#=>  ["ham", "Hope you are not scared!"]]
 ```
