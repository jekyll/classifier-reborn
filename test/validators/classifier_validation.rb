# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/classifier-reborn/validators/classifier_validator'
require_relative '../data/test_data_loader'

class ClassifierValidation < Minitest::Test
  class ValidationReporter < Minitest::Reporters::BaseReporter
    REPORT_WIDTH = 80

    def before_suite(suite)
      puts
      puts "# #{suite}"
      puts
    end

    def after_suite(suite)
      puts
    end

    def before_test(test)
      super
      validation_name = test.name.gsub(/^test_/, '')
      puts " #{validation_name} ".center(REPORT_WIDTH, "=")
    end

    def after_test(test)
      super
      puts "-" * REPORT_WIDTH
      puts
    end

    def report
      super
      puts('Finished in %.5fs' % total_time)
      puts
    end
  end
  Minitest::Reporters.use! ValidationReporter.new

  SAMPLE_SIZE = 5000

  def setup
    data = TestDataLoader.sms_data
    if data.length < SAMPLE_SIZE
      TestDataLoader.report_insufficient_data(data.length, SAMPLE_SIZE)
      skip(e)
    end
    @sample_data = data.take(SAMPLE_SIZE).collect { |line| line.strip.split("\t") }
  end

  def test_bayes_classifier_10_fold_cross_validate_memory
    classifier = ClassifierReborn::Bayes.new
    ClassifierValidator.cross_validate(classifier, @sample_data)
  end

  def test_bayes_classifier_3_fold_cross_validate_redis
    begin
      backend = ClassifierReborn::BayesRedisBackend.new
      backend.instance_variable_get(:@redis).config(:set, "save", "")
      classifier = ClassifierReborn::Bayes.new backend: backend
      ClassifierValidator.cross_validate(classifier, @sample_data, 3)
    rescue Redis::CannotConnectError => e
      puts "Unable to connect to Redis server"
      skip(e)
    end
  end

  def test_lsi_classifier_5_fold_cross_validate
    lsi = ClassifierReborn::LSI.new
    required_methods = [:train, :classify, :categories]
    unless required_methods.reduce(true){|m, o| m && lsi.respond_to?(o)}
      puts "TODO: LSI is not validatable until all of the #{required_methods} methods are implemented!"
      skip
    end
    ClassifierValidator.cross_validate(lsi, @sample_data, 5)
  end
end
