# encoding: utf-8
# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

require 'set'

require_relative 'tokenizer/whitespace'
require_relative 'token_filter/stopword'
require_relative 'token_filter/stemmer'

module ClassifierReborn
  module Hasher
    module_function

    # Return a Hash of strings => ints. Each word in the string is stemmed,
    # interned, and indexes to its frequency in the document.
    def word_hash(str, language = 'en', enable_stemmer = true, clean: false,
                  tokenizer: Tokenizer::Whitespace,
                  token_filters: [])
      tikenize_options = {
        language:       language,
        enable_stemmer: enable_stemmer,
        clean:          clean,
      }
      words = tokenizer.tokenize(str, tikenize_options)
      token_filters.each do |token_filter|
        words = token_filter.filter(words, tikenize_options)
      end
      d = Hash.new(0)
      words.each do |word|
        d[word.intern] += 1
      end
      d
    end
  end
end
