# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_benchmarks'

class BayesianRedisBenchmark < Minitest::Benchmark
  MAX_RECORDS = 5000

  include BayesianCommonBenchmarks

  def self.bench_range
    (bench_exp(1, MAX_RECORDS) << MAX_RECORDS).uniq
  end

  def setup
    @data ||= load_data
    if @data.length < MAX_RECORDS
      skip("Not enough records in the dataset")
    end
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
    print "redis_"
  end

  def teardown
    self.class.bench_range.each do |n|
      @classifiers[n].instance_variable_get(:@backend).instance_variable_get(:@redis).flushdb
    end
  end
end
