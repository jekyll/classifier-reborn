# frozen_string_literal: true

module BackendCommonTests
  def test_initial_values
    assert @backend.total_words.zero?
    assert @backend.total_trainings.zero?
    assert @backend.category_keys.empty?
  end

  def test_total_words
    @backend.update_total_words(10)
    assert_equal 10, @backend.total_words
    @backend.update_total_words(-7)
    assert_equal 3, @backend.total_words
  end

  def test_total_trainings
    @backend.update_total_trainings(10)
    assert_equal 10, @backend.total_trainings
    @backend.update_total_trainings(-7)
    assert_equal 3, @backend.total_trainings
  end

  def test_category_training
    refute @backend.category_has_trainings?(:Interesting)
    @backend.update_category_training_count(:Interesting, 10)
    assert @backend.category_has_trainings?(:Interesting)
    assert_equal 10, @backend.category_training_count(:Interesting)
    @backend.update_category_training_count(:Interesting, -7)
    assert_equal 3, @backend.category_training_count(:Interesting)
  end

  def test_category_word
    @backend.update_category_word_count(:Interesting, 10)
    assert_equal 10, @backend.category_word_count(:Interesting)
    @backend.update_category_word_count(:Interesting, -7)
    assert_equal 3, @backend.category_word_count(:Interesting)
  end

  def test_category
    @backend.add_category(:Interesting)
    @backend.add_category(:"Not so interesting")
    assert_equal [:Interesting, :"Not so interesting"].sort, @backend.category_keys.sort
  end

  def test_category_word_frequency
    @backend.add_category(:Interesting)
    refute @backend.word_in_category?(:Interesting, 'foo')
    assert_equal 0, @backend.category_word_frequency(:Interesting, 'foo')
    @backend.update_category_word_frequency(:Interesting, 'foo', 10)
    assert @backend.word_in_category?(:Interesting, 'foo')
    assert_equal 10, @backend.category_word_frequency(:Interesting, 'foo')
    @backend.update_category_word_frequency(:Interesting, 'foo', -7)
    assert_equal 3, @backend.category_word_frequency(:Interesting, 'foo')
    @backend.delete_category_word(:Interesting, 'foo')
    refute @backend.word_in_category?(:Interesting, 'foo')
  end

  def test_reset
    @backend.update_total_words(10)
    @backend.update_total_trainings(10)
    @backend.add_category(:Interesting)
    @backend.update_category_training_count(:Interesting, 10)
    @backend.update_category_word_count(:Interesting, 10)
    @backend.reset
    assert @backend.total_words.zero?
    assert @backend.total_trainings.zero?
    assert @backend.category_keys.empty?
  end
end
