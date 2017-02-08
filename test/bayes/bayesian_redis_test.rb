# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_tests'

class BayesianRedisTest < Minitest::Test
  include BayesianCommonTests

  def setup
    begin
      @old_stopwords = Hasher::STOPWORDS['en']
      @backend = ClassifierReborn::BayesRedisBackend.new
      @backend.instance_variable_get(:@redis).config(:set, "save", "")
      @alternate_backend = ClassifierReborn::BayesRedisBackend.new(db: 1)
      @classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting', backend: @backend
    rescue Redis::CannotConnectError => e
      skip(e)
    end
  end

  def teardown
    Hasher::STOPWORDS['en'] = @old_stopwords
    if defined? @backend
      @backend.reset
      @alternate_backend.reset
    end
  end
end
