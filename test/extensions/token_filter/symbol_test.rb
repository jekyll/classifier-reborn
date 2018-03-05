require_relative '../../test_helper'
require 'tempfile'

class TokenFilterSymbolTest < Minitest::Test
  def test_symbol
    words = %w(term ! ?).collect do |word|
      Tokenizer::Token.new(word)
    end
    words = TokenFilter::Symbol.call(words)
    assert_equal %w(term), words
  end
end
