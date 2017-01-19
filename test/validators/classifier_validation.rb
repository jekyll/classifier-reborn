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
    @classifier = ClassifierReborn::Bayes.new("Ham", "Spam")
  end

  def test_bayes_classifier_validate
    ClassifierReborn::ClassifierValidator.cross_validate(@classifier, @sample_data)
  end

  def test_lsi_classifier_validate
    puts "TODO: Implement it"
  end
end
