# encoding: utf-8

module BayesianCommonBenchmarks
  def load_data
    sms_spam_collection = File.expand_path(File.dirname(__FILE__) + '/../data/corpus/SMSSpamCollection.tsv')
    File.read(sms_spam_collection).force_encoding("utf-8").split("\n")
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
