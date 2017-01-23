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

## Custom Validation

While `k-fold` cross-validation is a pretty good and commonly used validation method, there might be cases where one wants to implement custom logic of how to split the sample data and how to perform one or more runs to combine the results.
Classifier Reborn provides with a `validate` method that accepts a classifier, training data, testing data, and optional hash to instantiate the classifier if the name of a classifier was supplied instead.
This method returns an associative confusion matrix hash that can then be supplied to stats calculation or report generation methods.

To illustrate a simple custom validation let's split the `sample_data` into test and training sets with one is to four ratio.

```ruby
test_data, training_data = sample_data.partition.with_index{|_, i| i % 5 == 0}
```

Now, using these data sets get the confusion matrix using `validate` method.

```ruby
conf_mat = validate("Bayes", training_data, test_data)
# Alternatively, an instance of a custom classifier can be created and supplied instead of the name
```

The returned confusion matrix looks like this.

```ruby
pp conf_mat
#=> {"Ham"=>{"Ham"=>828, "Spam"=>27},
#    "Spam"=>{"Ham"=>7, "Spam"=>138}}
```

The primary level keys of this nested hash represent the actual classes while the secondary level keys are predicted classes.
There can be more than two classes, but this hash will remain only two level deep as the number of classes does not affect the organization of this data structure.
This means, `conf_mat["Ham"][Spam"]` tells that there were 27 records that were actually `Ham`, but predicted as `Spam`.

We can now generate report from this data structure.

```ruby
generate_report(conf_mat)
```

This will yield the following report.

```
--------------- Run Report ----------------
Run     Total   Correct Incorrect  Accuracy
-------------------------------------------
All      1000       966        34   0.96600

----------------------- Confusion Matrix -----------------------
Predicted ->          Ham         Spam        Total       Recall
----------------------------------------------------------------
Ham                   828           27          855      0.96842
Spam                    7          138          145      0.95172
----------------------------------------------------------------
Total                 835          165         1000
Precision         0.99162      0.83636

# Positive class: Ham
Total population   : 1000
Condition positive : 855
Condition negative : 145
True positive      : 828
True negative      : 138
False positive     : 7
False negative     : 27
Prevalence         : 0.855
Specificity        : 0.9517241379310345
Recall             : 0.968421052631579
Precision          : 0.9916167664670659
Accuracy           : 0.966
F1 score           : 0.9798816568047337

# Positive class: Spam
Total population   : 1000
Condition positive : 145
Condition negative : 855
True positive      : 138
True negative      : 828
False positive     : 27
False negative     : 7
Prevalence         : 0.145
Specificity        : 0.968421052631579
Recall             : 0.9517241379310345
Precision          : 0.8363636363636363
Accuracy           : 0.966
F1 score           : 0.8903225806451613
```

This report is similar to the `k-fold` cross-validation method, except, it does not have multiple run reports in the first table.
However, `generate_report` method is capable of taking more than one `conf_mat` hashes in an array or separate arguments.
In that case, each `conf_mat` hash will be treated as individual run result and corresponding individual and accumulated reports will be generated.

Suppose we only want to generate the run reports, but no multi-class confusion matrix or other derived statics.

```ruby
run_report = build_run_report(conf_mat)
pp run_report
#=> {:total=>1000, :correct=>966, :incorrect=>34, :accuracy=>0.966}
```

This data can be used to print the report in a custom manner or utilize corresponding provided print method.

```ruby
print_run_report(run_report, "Custom", true)
```

This will print the following report where the last argument is set to `true` to print the header.

```
Run        Total   Correct Incorrect  Accuracy
Custom      1000       966        34   0.96600
```

Now, suppose we only want to generate the multi-class confusion matrix report, but no run reports or other derived statics.

```ruby
print_conf_mat(conf_mat)
```

This will print only the confusion matrix.

```
----------------------- Confusion Matrix -----------------------
Predicted ->          Ham         Spam        Total       Recall
----------------------------------------------------------------
Ham                   828           27          855      0.96842
Spam                    7          138          145      0.95172
----------------------------------------------------------------
Total                 835          165         1000
Precision         0.99162      0.83636
```

We can convert this multi-class confusion matrix data `conf_mat` to corresponding confusion table.
Although, in information retrieval world, confusion matrix and confusion table are the same thing, here we are establishing a difference that the confusion table will only have binary classes (`positive` and `negative`).
This will divide records in true positives (TP), true negatives (TN), false positives (FP), and false negatives (FN).
A multi-class confusion matrix can be converted to corresponding confusion table by treating one class as positive and every other class as negative.
If the same process is repeated for each class taken as positive one at a time, we will get `N` confusion tables for a classifier with `N` classes.
We have a method `conf_mat_to_tab` to perform this conversion.

```ruby
conf_tab = conf_mat_to_tab(conf_mat)
pp conf_tab
#=> {"Ham"=>{:p=>{:t=>828, :f=>7}, :n=>{:t=>138, :f=>27}},
#    "Spam"=>{:p=>{:t=>138, :f=>27}, :n=>{:t=>828, :f=>7}}}
```

This means, `conf_tab["Ham"][:p][:t]` tells that taking `Ham` as the positive class, there were 828 records that were predicted as positive and the prediction was true (also known as true positives or `TP`).

We can pass this `conf_tab` hash to the `print_conf_tab` method to print various derived statistical values for each class.
However, if we are only interested in one class to be treated as the positive class (e.g., `Ham`) then we can extract the derived values of only that class.

```ruby
derivations = conf_tab_derivations(conf_tab["Ham"])
pp derivations
#=> {:total_population=>1000,
#    :condition_positive=>855,
#    :condition_negative=>145,
#    :true_positive=>828,
#    :true_negative=>138,
#    :false_positive=>7,
#    :false_negative=>27,
#    :prevalence=>0.855,
#    :specificity=>0.9517241379310345,
#    :recall=>0.968421052631579,
#    :precision=>0.9916167664670659,
#    :accuracy=>0.966,
#    :f1_score=>0.9798816568047337}
```

These derivation can then be printed in a more human readable format.

```ruby
print_derivations(derivations)
```

This will print a properly capitalized and aligned report.

```
Total population   : 1000
Condition positive : 855
Condition negative : 145
True positive      : 828
True negative      : 138
False positive     : 7
False negative     : 27
Prevalence         : 0.855
Specificity        : 0.9517241379310345
Recall             : 0.968421052631579
Precision          : 0.9916167664670659
Accuracy           : 0.966
F1 score           : 0.9798816568047337
```
