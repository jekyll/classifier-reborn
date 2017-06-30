require_relative '../../test_helper'
require 'tempfile'

class TokenizerWhitespaceTest < Minitest::Test
  def test_tokenize
    tokens = %w(here are some good words of tests i hope you love them ' . !)
    stemmabilities = [true, true, true, true, true, true, true, true, true, true, true, true, false, false, false]
    maybe_stopwords = [true, true, true, true, true, true, true, true, true, true, true, true, false, false, false]

    actual_tokens = Tokenizer::Whitespace.tokenize("here are some good words of test's. I hope you love them!")
    assert_equal tokens, actual_tokens
    assert_equal stemmabilities, actual_tokens.collect(&:stemmable?)
    assert_equal maybe_stopwords, actual_tokens.collect(&:maybe_stopword?)
  end
end
