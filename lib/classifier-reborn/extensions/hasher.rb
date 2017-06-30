# encoding: utf-8
# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

require 'set'

require_relative 'tokenizer/whitespace'
require_relative 'token_filter/stopword'

module ClassifierReborn
  module Hasher
    module_function

    # Return a Hash of strings => ints. Each word in the string is stemmed,
    # interned, and indexes to its frequency in the document.
    def word_hash(str, language = 'en', enable_stemmer = true)
      cleaned_word_hash = clean_word_hash(str, language, enable_stemmer)
      symbol_hash = word_hash_for_symbols(str.scan(/[^\s\p{WORD}]/))
      cleaned_word_hash.merge(symbol_hash)
    end

    # Return a word hash without extra punctuation or short symbols, just stemmed words
    def clean_word_hash(str, language = 'en', enable_stemmer = true)
      words = Tokenizer::Whitespace.tokenize(str)
      words = TokenFilter::Stopword.filter(words, language)
      word_hash_for_words(words, language, enable_stemmer)
    end

    def word_hash_for_words(words, language = 'en', enable_stemmer = true)
      d = Hash.new(0)
      words.each do |word|
        if enable_stemmer
          d[word.stem.intern] += 1
        else
          d[word.intern] += 1
        end
      end
      d
    end

    def word_hash_for_symbols(words)
      d = Hash.new(0)
      words.each do |word|
        d[word.intern] += 1
      end
      d
    end
  end
end
