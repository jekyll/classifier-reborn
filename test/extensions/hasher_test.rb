require_relative '../test_helper'
require 'tempfile'

class HasherTest < Minitest::Test
  def setup
    @original_stopwords_path = TokenFilter::Stopword::STOPWORDS_PATH.dup
  end

  def test_word_hash
    hash = { good: 1, :'!' => 1, hope: 1, :"'" => 1, :'.' => 1, love: 1, word: 1, them: 1, test: 1 }
    assert_equal hash, Hasher.word_hash("here are some good words of test's. I hope you love them!")
  end

  module BigramTokenizer
    module_function
    def call(str)
      str.each_char
         .each_cons(2)
         .map do |chars| ::ClassifierReborn::Tokenizer::Token.new(chars.join) end
    end
  end

  def test_custom_tokenizer_module
    hash = { te: 1, er: 1, rm: 1 }
    assert_equal hash, Hasher.word_hash("term", tokenizer: BigramTokenizer, token_filters: [])
  end

  def test_custom_tokenizer_lambda
    hash = { te: 1, er: 1, rm: 1 }
    bigram_tokenizer = lambda do |str|
      str.each_char
         .each_cons(2)
         .map do |chars| ::ClassifierReborn::Tokenizer::Token.new(chars.join) end
    end
    assert_equal hash, Hasher.word_hash("term", tokenizer: bigram_tokenizer, token_filters: [])
  end

  module CatFilter
    module_function
    def call(tokens)
      tokens.reject do |token|
        /\Acat\z/i === token
      end
    end
  end

  def test_custom_token_filters_module
    hash = { dog: 1 }
    assert_equal hash, Hasher.word_hash("cat dog", token_filters: [CatFilter])
  end

  def test_custom_token_filters_lambda
    hash = { dog: 1 }
    cat_filter = lambda do |tokens|
      tokens.reject do |token|
        /\Acat\z/i === token
      end
    end
    assert_equal hash, Hasher.word_hash("cat dog", token_filters: [cat_filter])
  end

  def teardown
    TokenFilter::Stopword::STOPWORDS.clear
    TokenFilter::Stopword::STOPWORDS_PATH.clear.concat @original_stopwords_path
  end
end
