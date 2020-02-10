# frozen_string_literal: true

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
    def word_hash(str, enable_stemmer = true,
                  tokenizer: Tokenizer::Whitespace,
                  token_filters: [TokenFilter::Stopword])
      if token_filters.include?(TokenFilter::Stemmer)
        unless enable_stemmer
          token_filters.reject! do |token_filter|
            token_filter == TokenFilter::Stemmer
          end
        end
      else
        token_filters << TokenFilter::Stemmer if enable_stemmer
      end
      words = tokenizer.call(str)
      token_filters.each do |token_filter|
        words = token_filter.call(words)
      end
      d = Hash.new(0)
      words.each do |word|
        d[word.intern] += 1
      end
      d
    end
  end
end
