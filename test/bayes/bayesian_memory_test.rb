# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_tests'

class BayesianMemoryTest < Minitest::Test
  include BayesianCommonTests

  def setup
    @classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting'
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
end
