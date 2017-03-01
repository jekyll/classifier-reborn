require_relative '../test_helper'
require 'tempfile'

class HasherTest < Minitest::Test
  def setup
    @original_stopwords_path = Hasher::STOPWORDS_PATH.dup
  end

  def test_word_hash
    hash = { good: 1, :'!' => 1, hope: 1, :"'" => 1, :'.' => 1, love: 1, word: 1, them: 1, test: 1 }
    assert_equal hash, Hasher.word_hash("here are some good words of test's. I hope you love them!")
  end

  def test_clean_word_hash
    hash = { good: 1, word: 1, hope: 1, love: 1, them: 1, test: 1 }
    assert_equal hash, Hasher.clean_word_hash("here are some good words of test's. I hope you love them!")
  end

  def test_clean_word_hash_without_stemming
    hash = { good: 1, words: 1, hope: 1, love: 1, them: 1, tests: 1 }
    assert_equal hash, Hasher.clean_word_hash("here are some good words of test's. I hope you love them!", 'en', false)
  end

  def test_default_stopwords
    refute_empty Hasher::STOPWORDS['en']
    refute_empty Hasher::STOPWORDS['fr']
    assert_empty Hasher::STOPWORDS['gibberish']
  end

  def test_loads_custom_stopwords
    default_english_stopwords = Hasher::STOPWORDS['en']

    # Remove the english stopwords
    Hasher::STOPWORDS.delete('en')

    # Add a custom stopwords path
    Hasher::STOPWORDS_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../data/stopwords')

    custom_english_stopwords = Hasher::STOPWORDS['en']

    refute_equal default_english_stopwords, custom_english_stopwords
  end

  def test_add_custom_stopword_path
    # Create stopword tempfile in current directory
    temp_stopwords = Tempfile.new('xy', "#{File.dirname(__FILE__) + "/"}")

    # Add some stopwords to tempfile
    temp_stopwords << "this words fun"
    temp_stopwords.close

    # Get path of tempfile
    temp_stopwords_path = File.dirname(temp_stopwords)

    # Get tempfile name.
    temp_stopwords_name = File.basename(temp_stopwords.path)

    Hasher.add_custom_stopword_path(temp_stopwords_path)
    hash = {:is=>1, :a=>1, :list=>1, :of=>1, :cool=>1}
    assert_equal hash, Hasher.clean_word_hash("this is a list of cool words!", temp_stopwords_name)
  end

  def teardown
    Hasher::STOPWORDS.clear
    Hasher::STOPWORDS_PATH.clear.concat @original_stopwords_path
  end
end
