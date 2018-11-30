require_relative '../../test_helper'
require 'tempfile'

class TokenizerTokenTest < Minitest::Test
  class StemmableTest < self
    def test_stemmable
      token = Tokenizer::Token.new('word', stemmable: true)
      assert_equal 'word', token
      assert token.stemmable?
    end

    def test_not_stemmable
      token = Tokenizer::Token.new('word', stemmable: false)
      assert_equal 'word', token
      assert !token.stemmable?
    end
  end

  class StemTest < self
    def test_maybe_stopword
      token = Tokenizer::Token.new('numbers', maybe_stopword: true)
      stemmed = token.stem
      assert_equal 'number', stemmed
      assert stemmed.maybe_stopword?
    end

    def test_not_stopword
      token = Tokenizer::Token.new('do', maybe_stopword: false)
      stemmed = token.stem
      assert_equal 'do', stemmed
      assert !stemmed.maybe_stopword?
    end
  end
end
