require_relative '../../test_helper'
require 'tempfile'

class TokenFilterStemmerTest < Minitest::Test
  def test_stemming
    words = %w(numbers words).collect do |word|
      Tokenizer::Token.new(word, stemmable: true)
    end
    words = TokenFilter::Stemmer.filter(words)
    assert_equal %w(number word), words
  end
end
