# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_benchmarks'

class BayesianMemoryBenchmark < Minitest::Benchmark
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
    self.class.bench_range.each do |n|
      @classifiers[n] = ClassifierReborn::Bayes.new 'Ham', 'Spam'
    end
    print "memory_"
  end
end
