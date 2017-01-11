# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_benchmarks'
require_relative '../data/test_data_loader'

class BayesianMemoryBenchmark < Minitest::Benchmark
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
    self.class.bench_range.each do |n|
      @classifiers[n] = ClassifierReborn::Bayes.new 'Ham', 'Spam'
    end
  end
end
