# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require_relative './backend_common_tests'

class BackendMemoryTest < Minitest::Test
  include BackendCommonTests

  def setup
    @backend = ClassifierReborn::BayesMemoryBackend.new
  end

  def test_persistence
    @backend.update_total_words(10)
    @backend.update_total_trainings(10)
    @backend.add_category(:Interesting)
    @backend.update_category_training_count(:Interesting, 10)
    @backend.update_category_word_count(:Interesting, 10)
    @backend.update_category_word_frequency(:Interesting, 'foo', 10)

    binary = Marshal.dump(@backend)
    loaded_backend = Marshal.load(binary)

    assert_equal @backend.total_words, loaded_backend.total_words
    assert_equal @backend.total_trainings, loaded_backend.total_trainings
    assert_equal @backend.category_training_count(:Interesting), loaded_backend.category_training_count(:Interesting)
    assert_equal @backend.category_word_count(:Interesting), loaded_backend.category_word_count(:Interesting)
    assert_equal @backend.category_word_frequency(:Interesting, 'foo'),
                 loaded_backend.category_word_frequency(:Interesting, 'foo')
  end
end
