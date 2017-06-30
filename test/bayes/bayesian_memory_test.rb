# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './bayesian_common_tests'

class BayesianMemoryTest < Minitest::Test
  include BayesianCommonTests

  def setup
    @alternate_backend = ClassifierReborn::BayesMemoryBackend.new
    @classifier = ClassifierReborn::Bayes.new 'Interesting', 'Uninteresting'
    @old_stopwords = TokenFilter::Stopword::STOPWORDS['en']
  end

  def teardown
    TokenFilter::Stopword::STOPWORDS['en'] = @old_stopwords
  end
end
