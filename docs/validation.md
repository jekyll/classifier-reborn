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
include ClassifierReborn::ClassifierValidator

tsv_file_path = "test/data/corpus/SMSSpamCollection.tsv"
data = File.read(tsv_file_path).force_encoding("utf-8").split("\n")
sample_data = data.take(5000).collect{|line| line.strip.split("\t")}
```

Although, loading `classifier-reborn` is not needed just yet, but we will need it as we extend this script incrementally.
Additionally, we have included the `ClassifierReborn::ClassifierValidator` module to make its methods available locally without the need of repeating the namespace.
The `sample_data` is in the required format now.
Here is what it looks like.

```ruby
pp sample_data.sample(4)
#=> [["ham", "Yeah that's the impression I got"],
#    ["ham", "I was slept that time.you there?"],
#    ["spam", "Win a £1000 cash prize or a prize worth £5000"],
#    ["ham", "Hope you are not scared!"]]
 ```

## K-fold Cross-validation

Let's begin with standard [k-fold cross-validation](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#k-fold_cross-validation).
We pass the name of the classifier to validate (`Bayes` in this example), the samaple data (`sample_data` we created in the last step), and the number of folds (5 in this case) to the `cross_validate` method.
The default value of `k` (number of folds) is set to 10, if not specified.
Classifier initialization options, if any, can be supplied as hash as the last argument.

```ruby
cross_validate("Bayes", sample_data, 5)
```

Alternatively, a classifier instance can be created with custom arguments and supplied in place of the name of the classifier as illustrated below.

```ruby
classifier = ClassifierReborn::Bayes.new("Ham", "Spam", stopwords: "/path/to/custom/stopwords/file")
cross_validate(classifier, sample_data, 5)
```

Once the validation runs are completed following report will be generated.

```
--------------- Run Report ----------------
Run     Total   Correct Incorrect  Accuracy
-------------------------------------------
  1      1000       972        28   0.97200
  2      1000       973        27   0.97300
  3      1000       981        19   0.98100
  4      1000       981        19   0.98100
  5      1000       967        33   0.96700
-------------------------------------------
All      5000      4874       126   0.97480

----------------------- Confusion Matrix -----------------------
Predicted ->          Ham         Spam        Total       Recall
----------------------------------------------------------------
Ham                  4225          102         4327      0.97643
Spam                   24          649          673      0.96434
----------------------------------------------------------------
Total                4249          751         5000
Precision         0.99435      0.86418

# Positive class: Ham
Total population   : 5000
Condition positive : 4327
Condition negative : 673
True positive      : 4225
True negative      : 649
False positive     : 24
False negative     : 102
Prevalence         : 0.8654
Specificity        : 0.9643387815750372
Recall             : 0.9764270857406979
Precision          : 0.9943516121440339
Accuracy           : 0.9748
F1 score           : 0.9853078358208955

# Positive class: Spam
Total population   : 5000
Condition positive : 673
Condition negative : 4327
True positive      : 649
True negative      : 4225
False positive     : 102
False negative     : 24
Prevalence         : 0.1346
Specificity        : 0.9764270857406979
Recall             : 0.9643387815750372
Precision          : 0.8641810918774967
Accuracy           : 0.9748
F1 score           : 0.9115168539325843
```

The first table in the above report is a summary of each individual runs (of k-folds) followed by the overall accumulated summary line at the end.

The second table is a standard multi-class [Confusion Matrix](https://en.wikipedia.org/wiki/Confusion_matrix).
Along with the cross-matching counts of actual and predicted classes it also shows per class recall column and per class precision row at the ends.

At the end there are various derived statistical measures listed for each class taken as the positive class one at a time (in [one-vs.-rest](https://en.wikipedia.org/wiki/Multiclass_classification#One-vs.-rest) manner).
