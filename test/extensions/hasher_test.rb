require_relative '../test_helper'
require 'tempfile'

class HasherTest < Minitest::Test
  def setup
    @original_stopwords_path = TokenFilter::Stopword::STOPWORDS_PATH.dup
  end

  def test_word_hash
    hash = { good: 1, '!': 1, hope: 1, "'": 1, '.': 1, love: 1, word: 1, them: 1, test: 1 }
    assert_equal hash, Hasher.word_hash("here are some good words of test's. I hope you love them!")
  end

  module BigramTokenizer
    module_function

    def call(str)
      str.each_char
         .each_cons(2)
         .map { |chars| ::ClassifierReborn::Tokenizer::Token.new(chars.join) }
    end
  end

  def test_custom_tokenizer_module
    hash = { te: 1, er: 1, rm: 1 }
    assert_equal hash, Hasher.word_hash('term', tokenizer: BigramTokenizer, token_filters: [])
  end

  class BigramTokenizerClass
    def call(str)
      BigramTokenizer.call(str)
    end

    def self.call(str)
      BigramTokenizer.call(str)
    end
  end

  def test_custom_tokenizer_class
    hash = { te: 1, er: 1, rm: 1 }
    assert_equal hash, Hasher.word_hash('term', tokenizer: BigramTokenizerClass, token_filters: [])
  end

  def test_custom_tokenizer_instance
    hash = { te: 1, er: 1, rm: 1 }
    bigram_tokenizer = BigramTokenizerClass.new
    assert_equal hash, Hasher.word_hash('term', tokenizer: bigram_tokenizer, token_filters: [])
  end

  def test_custom_tokenizer_lambda
    hash = { te: 1, er: 1, rm: 1 }
    bigram_tokenizer = lambda do |str|
      BigramTokenizer.call(str)
    end
    assert_equal hash, Hasher.word_hash('term', tokenizer: bigram_tokenizer, token_filters: [])
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
    assert_equal hash, Hasher.word_hash('cat dog', token_filters: [CatFilter])
  end

  class CatFilterClass
    def call(tokens)
      CatFilter.call(tokens)
    end

    def self.call(tokens)
      CatFilter.call(tokens)
    end
  end

  def test_custom_token_filters_class
    hash = { dog: 1 }
    assert_equal hash, Hasher.word_hash('cat dog', token_filters: [CatFilterClass])
  end

  def test_custom_token_filters_instance
    hash = { dog: 1 }
    cat_filter = CatFilterClass.new
    assert_equal hash, Hasher.word_hash('cat dog', token_filters: [cat_filter])
  end

  def test_custom_token_filters_lambda
    hash = { dog: 1 }
    cat_filter = lambda do |tokens|
      CatFilter.call(tokens)
    end
    assert_equal hash, Hasher.word_hash('cat dog', token_filters: [cat_filter])
  end

  def teardown
    TokenFilter::Stopword::STOPWORDS.clear
    TokenFilter::Stopword::STOPWORDS_PATH.clear.concat @original_stopwords_path
  end
end
