require File.dirname(__FILE__) + '/../test_helper'

class HasherTest < Test::Unit::TestCase
  def setup
    @original_stopwords_path = Hasher::STOPWORDS_PATH.dup
  end

  def test_word_hash
    hash = { good: 1, "!": 1, hope: 1, "'": 1, ".": 1, love: 1, word: 1, them: 1, test: 1 }
    assert_equal hash, Hasher.word_hash("here are some good words of test's. I hope you love them!")
  end

  def test_clean_word_hash
    hash = { good: 1, word: 1, hope: 1, love: 1, them: 1, test: 1 }
    assert_equal hash, Hasher.clean_word_hash("here are some good words of test's. I hope you love them!")
  end

  def test_default_stopwords
    assert_not_empty Hasher::STOPWORDS['en']
    assert_not_empty Hasher::STOPWORDS['fr']
    assert_empty Hasher::STOPWORDS['gibberish']
  end

  def test_loads_custom_stopwords
    default_english_stopwords = Hasher::STOPWORDS['en']

    # Remove the english stopwords
    Hasher::STOPWORDS.delete('en')

    # Add a custom stopwords path
    Hasher::STOPWORDS_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../data/stopwords')

    custom_english_stopwords = Hasher::STOPWORDS['en']

    assert_not_equal default_english_stopwords, custom_english_stopwords
  end

  def teardown
    Hasher::STOPWORDS.clear
    Hasher::STOPWORDS_PATH.clear.concat @original_stopwords_path
  end
end
