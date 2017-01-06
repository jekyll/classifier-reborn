# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_tests'

class BayesianRedisTest < Minitest::Test
  include BayesianCommonTests

  def setup
    begin
      @redis_backend = ClassifierReborn::BayesRedisBackend.new
      @redis_backend.instance_variable_get(:@redis).config(:set, "save", "")
      @alternate_redis_backend = ClassifierReborn::BayesRedisBackend.new(db: 1)
      @classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting', backend: @redis_backend
    rescue Redis::CannotConnectError => e
      skip(e)
    end
  end

  def teardown
    @redis_backend.instance_variable_get(:@redis).flushdb
    @alternate_redis_backend.instance_variable_get(:@redis).flushdb
  end

  def another_classifier
    ClassifierReborn::Bayes.new %w(Interesting Uninteresting), backend: @alternate_redis_backend
  end

  def auto_categorize_classifier
    ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting', auto_categorize: true, backend: @alternate_redis_backend
  end

  def threshold_classifier(category)
    ClassifierReborn::Bayes.new category, backend: @alternate_redis_backend
  end
end
