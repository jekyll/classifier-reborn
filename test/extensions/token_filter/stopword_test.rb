require_relative '../../test_helper'
require 'tempfile'

class TokenFilterStopwordTest < Minitest::Test
  def setup
    @original_stopwords_path = TokenFilter::Stopword::STOPWORDS_PATH.dup
  end

  def test_default_stopwords
    refute_empty TokenFilter::Stopword::STOPWORDS['en']
    refute_empty TokenFilter::Stopword::STOPWORDS['fr']
    assert_empty TokenFilter::Stopword::STOPWORDS['gibberish']
  end

  def test_loads_custom_stopwords
    default_english_stopwords = TokenFilter::Stopword::STOPWORDS['en']

    # Remove the english stopwords
    TokenFilter::Stopword::STOPWORDS.delete('en')

    # Add a custom stopwords path
    TokenFilter::Stopword::STOPWORDS_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../data/stopwords')

    custom_english_stopwords = TokenFilter::Stopword::STOPWORDS['en']

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

    TokenFilter::Stopword.add_custom_stopword_path(temp_stopwords_path)
    words = Tokenizer::Whitespace.tokenize("this is a list of cool words!")
    words = TokenFilter::Stopword.filter(words, language: temp_stopwords_name)
    assert_equal %w(list cool !), words
  end

  def teardown
    TokenFilter::Stopword::STOPWORDS.clear
    TokenFilter::Stopword::STOPWORDS_PATH.clear.concat @original_stopwords_path
  end
end
