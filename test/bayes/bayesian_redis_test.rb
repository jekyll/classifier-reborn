# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_tests'

class BayesianRedisTest < Minitest::Test
  include BayesianCommonTests

  def setup
    begin
      @classifier = ClassifierReborn::Bayes.new('Interesting', 'Uninteresting', {backend: ClassifierReborn::BayesRedisBackend.new})
    rescue Redis::CannotConnectError => e
      omit(e)
    end
  end

  def teardown
    @classifier.instance_variable_get(:@backend).instance_variable_get(:@redis).flushdb
  end
end
