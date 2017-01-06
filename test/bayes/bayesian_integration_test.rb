# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'

class BayesianIntegrationTest < Minitest::Test
  def setup
    begin
      @memory_classifier = ClassifierReborn::Bayes.new 'Ham', 'Spam'
      @redis_backend = ClassifierReborn::BayesRedisBackend.new
      @redis_classifier = ClassifierReborn::Bayes.new 'Ham', 'Spam', backend: @redis_backend
    rescue Redis::CannotConnectError => e
      skip(e)
    end
    sms_spam_collection = File.expand_path(File.dirname(__FILE__) + '/../data/corpus/SMSSpamCollection.tsv')
    @training_set = File.read(sms_spam_collection).force_encoding("utf-8").split("\n")
    @testing_set = @training_set.pop(1000)
  end

  def teardown
    @redis_backend.instance_variable_get(:@redis).flushdb
  end

  def test_equality_of_backends
    train_model @memory_classifier
    train_model @redis_classifier
    assert_equal classification_scores(@memory_classifier).hash, classification_scores(@redis_classifier).hash
    untrain_model @memory_classifier, 2000
    untrain_model @redis_classifier, 2000
    assert_equal classification_scores(@memory_classifier).hash, classification_scores(@redis_classifier).hash
  end

  def train_model(classifier)
    @training_set.each do |line|
      parts = line.strip.split("\t")
      classifier.train(parts.first, parts.last)
    end
  end

  def untrain_model(classifier, limit=Float::INFINITY)
    @training_set.each_with_index do |line, i|
      break if i >= limit
      parts = line.strip.split("\t")
      classifier.untrain(parts.first, parts.last)
    end
  end

  def classification_scores(classifier)
    @testing_set.collect do |line|
      parts = line.strip.split("\t")
      result, score = classifier.classify_with_score(parts.last)
      "#{result}:#{score}"
    end
  end
end
