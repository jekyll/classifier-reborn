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

  def self.load_data
    sms_spam_collection = File.expand_path(File.dirname(__FILE__) + '/../data/corpus/SMSSpamCollection.tsv')
    lines = File.read(sms_spam_collection).force_encoding("utf-8").split("\n")
    puts "\n\e[31mInsufficient records in the dataset: available #{lines.length}, required #{MAX_RECORDS}\e[0m\n\n" if lines.length < MAX_RECORDS
    lines
  end

  def self.insufficient_data?
    self.data.length < MAX_RECORDS
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
