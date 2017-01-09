# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_benchmarks'

class BayesianRedisBenchmark < Minitest::Benchmark
  include BayesianCommonBenchmarks

  def self.bench_range
    BayesianCommonBenchmarks.bench_range
  end

  def setup
    skip if BayesianCommonBenchmarks.insufficient_data?
    @data = BayesianCommonBenchmarks.data
    @classifiers = {}
    self.class.bench_range.each_with_index do |n, i|
      begin
        redis_backend = ClassifierReborn::BayesRedisBackend.new(db: i)
        redis_backend.instance_variable_get(:@redis).config(:set, "save", "")
        @classifiers[n] = ClassifierReborn::Bayes.new 'Ham', 'Spam', backend: redis_backend
      rescue Redis::CannotConnectError => e
        skip(e)
      end
    end
  end

  def teardown
    if defined? @classifiers
      self.class.bench_range.each do |n|
        @classifiers[n].instance_variable_get(:@backend).instance_variable_get(:@redis).flushdb
      end
    end
  end
end
