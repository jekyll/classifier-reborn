# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_tests'

class BayesianRedisTest < Minitest::Test
  include BayesianCommonTests

  def setup
    begin
      @classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting', backend: ClassifierReborn::BayesRedisBackend.new
    rescue Redis::CannotConnectError => e
      skip(e)
    end
  end

  def teardown
    @classifier.instance_variable_get(:@backend).instance_variable_get(:@redis).flushall
  end

  def another_classifier
    ClassifierReborn::Bayes.new %w(Interesting Uninteresting), backend: ClassifierReborn::BayesRedisBackend.new(db: 1)
  end

  def auto_categorize_classifier
    ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting', auto_categorize: true, backend: ClassifierReborn::BayesRedisBackend.new(db: 1)
  end

  def threshold_classifier(category)
    ClassifierReborn::Bayes.new category, backend: ClassifierReborn::BayesRedisBackend.new(db: 1)
  end
end
