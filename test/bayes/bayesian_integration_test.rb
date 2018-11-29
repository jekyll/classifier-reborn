# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative '../data/test_data_loader'

class BayesianIntegrationTest < Minitest::Test
  TRAINING_SIZE = 4000
  TESTING_SIZE = 1000

  def setup
    begin
      @memory_classifier = ClassifierReborn::Bayes.new 'Ham', 'Spam'
      @redis_backend = ClassifierReborn::BayesRedisBackend.new
      @redis_backend.instance_variable_get(:@redis).config(:set, "save", "")
      @redis_classifier = ClassifierReborn::Bayes.new 'Ham', 'Spam', backend: @redis_backend
    rescue Redis::CannotConnectError => e
      skip(e)
    end
    data = TestDataLoader.sms_data
    if data.length < TRAINING_SIZE + TESTING_SIZE
      TestDataLoader.report_insufficient_data(data.length, TRAINING_SIZE + TESTING_SIZE)
      skip(e)
    end
    @training_set = data[0, TRAINING_SIZE]
    @testing_set = data[TRAINING_SIZE, TESTING_SIZE]
  end

  def teardown
    @redis_backend.reset unless @redis_backend.nil?
  end

  def test_equality_of_backends
    train_model @memory_classifier
    train_model @redis_classifier
    assert_equal classification_scores(@memory_classifier).hash, classification_scores(@redis_classifier).hash
    untrain_model @memory_classifier, TRAINING_SIZE / 2
    untrain_model @redis_classifier, TRAINING_SIZE / 2
    assert_equal classification_scores(@memory_classifier).hash, classification_scores(@redis_classifier).hash
  end

  def train_model(classifier)
    @training_set.each do |line|
      parts = line.strip.split("\t")
      classifier.train(parts.first, parts.last)
    end
  end

  def untrain_model(classifier, limit = Float::INFINITY)
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
      score.infinite? ? "irrelevant" : "#{result}:#{score}"
    end
  end
end
