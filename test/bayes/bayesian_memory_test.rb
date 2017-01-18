# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_tests'

class BayesianMemoryTest < Minitest::Test
  include BayesianCommonTests

  def setup
    @classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting'
    @old_stopwords = Hasher::STOPWORDS['en']
  end

  def teardown
    Hasher::STOPWORDS['en'] = @old_stopwords
  end

  def another_classifier
    ClassifierReborn::Bayes.new %w(Interesting Uninteresting)
  end

  def auto_categorize_classifier
    ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting', auto_categorize: true
  end

  def threshold_classifier(category)
    ClassifierReborn::Bayes.new category
  end

  def empty_classifier
    ClassifierReborn::Bayes.new
  end

  def useless_classifier
    ClassifierReborn::Bayes.new auto_categorize: false
  end

  def empty_string_stopwords_classifier
    ClassifierReborn::Bayes.new stopwords: ""
  end

  def empty_array_stopwords_classifier
    ClassifierReborn::Bayes.new stopwords: []
  end

  def array_stopwords_classifier
    ClassifierReborn::Bayes.new stopwords: ["these", "are", "custom", "stopwords"]
  end

  def file_stopwords_classifier
    ClassifierReborn::Bayes.new stopwords: File.dirname(__FILE__) + '/../data/stopwords/en'
  end
end
