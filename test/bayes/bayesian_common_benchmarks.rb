# encoding: utf-8

module BayesianCommonBenchmarks
  MAX_RECORDS = 5000

  class BenchmarkReporter < Minitest::Reporters::BaseReporter
    include ANSI::Code

    def before_suite(suite)
      puts
      puts ([suite] + BayesianCommonBenchmarks.bench_range).join("\t")
    end

    def after_suite(suite)
    end

    def report
      super
      puts
      puts('Finished in %.5fs' % total_time)
      print('%d tests, %d assertions, ' % [count, assertions])
      color = failures.zero? && errors.zero? ? :green : :red
      print(send(color) { '%d failures, %d errors, ' } % [failures, errors])
      print(yellow { '%d skips' } % skips)
      puts
    end
  end
  Minitest::Reporters.use! BenchmarkReporter.new

  def self.bench_range
    (Minitest::Benchmark.bench_exp(1, MAX_RECORDS) << MAX_RECORDS).uniq
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
