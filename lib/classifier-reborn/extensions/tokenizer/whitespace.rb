# encoding: utf-8
# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

require_relative 'token'

module ClassifierReborn
  module Tokenizer
    module Whitespace
      module_function

      def tokenize(str)
        word_tokens = str.gsub(/[^\p{WORD}\s]/, '').downcase.split.collect do |word|
          Token.new(word, stemmable: true, maybe_stopword: true)
        end
        symbol_tokens = str.scan(/[^\s\p{WORD}]/).collect do |word|
          Token.new(word, stemmable: false, maybe_stopword: false)
        end
        word_tokens + symbol_tokens
      end
    end
  end
end
