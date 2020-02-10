# frozen_string_literal: true

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_benchmarks'
require_relative '../data/test_data_loader'

class BayesianRedisBenchmark < Minitest::Benchmark
  include BayesianCommonBenchmarks

  def self.bench_range
    BayesianCommonBenchmarks.bench_range
  end

  def setup
    @data = TestDataLoader.sms_data
    if insufficient_data?
      TestDataLoader.report_insufficient_data(@data.length, MAX_RECORDS)
      skip
    end
    @classifiers = {}
    self.class.bench_range.each_with_index do |n, i|
      begin
        redis_backend = ClassifierReborn::BayesRedisBackend.new(db: i)
        redis_backend.instance_variable_get(:@redis).config(:set, 'save', '')
        @classifiers[n] = ClassifierReborn::Bayes.new 'Ham', 'Spam', backend: redis_backend
      rescue Redis::CannotConnectError => e
        skip(e)
      end
    end
  end

  def teardown
    if defined? @classifiers
      self.class.bench_range.each do |n|
        @classifiers[n].reset
      end
    end
  end
end
