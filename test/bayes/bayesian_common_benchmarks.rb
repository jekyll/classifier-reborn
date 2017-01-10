# encoding: utf-8

module BayesianCommonBenchmarks
  MAX_RECORDS = 5000

  class BenchmarkReporter < Minitest::Reporters::RubyMateReporter
    def before_suite(suite)
      puts ([suite] + BayesianCommonBenchmarks.bench_range).join("\t")
    end
    def after_suite(suite)
      puts
    end
  end
  Minitest::Reporters.use! BenchmarkReporter.new

  def self.bench_range
    (Minitest::Benchmark.bench_exp(1, MAX_RECORDS) << MAX_RECORDS).uniq
  end

  def self.data
    @@data ||= self.load_data
  end

  def insufficient_data?
    @data.length < MAX_RECORDS
  end

  def bench_train
    assert_performance_linear do |n|
      n.times do |i|
        parts = @data[i].strip.split("\t")
        @classifiers[n].train(parts.first, parts.last)
      end
    end
  end

  def bench_train_untrain
    assert_performance_linear do |n|
      n.times do |i|
        parts = @data[i].strip.split("\t")
        @classifiers[n].train(parts.first, parts.last)
      end
      n.times do |i|
        parts = @data[i].strip.split("\t")
        @classifiers[n].untrain(parts.first, parts.last)
      end
    end
  end

  def bench_train_classify
    assert_performance_linear do |n|
      n.times do |i|
        parts = @data[i].strip.split("\t")
        @classifiers[n].train(parts.first, parts.last)
      end
      n.times do |i|
        parts = @data[i].strip.split("\t")
        @classifiers[n].classify(parts.last)
      end
    end
  end
end
