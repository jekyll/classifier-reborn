# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_benchmarks'

class BayesianMemoryBenchmark < Minitest::Benchmark
  include BayesianCommonBenchmarks

  def self.bench_range
    BayesianCommonBenchmarks.bench_range
  end

  def setup
    skip if BayesianCommonBenchmarks.insufficient_data?
    @data = BayesianCommonBenchmarks.data
    @classifiers = {}
    self.class.bench_range.each do |n|
      @classifiers[n] = ClassifierReborn::Bayes.new 'Ham', 'Spam'
    end
  end
end
