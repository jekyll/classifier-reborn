# encoding: utf-8
# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

require_relative 'token'

module ClassifierReborn
  module Tokenizer
    module Whitespace
      module_function

      def tokenize(str, language: 'en', enable_stemmer: true, clean: false)
        tokens = str.gsub(/[^\p{WORD}\s]/, '').downcase.split.collect do |word|
          Token.new(word, stemmable: true, maybe_stopword: true)
        end
        unless clean
        symbol_tokens = str.scan(/[^\s\p{WORD}]/).collect do |word|
          Token.new(word, stemmable: false, maybe_stopword: false)
        end
        tokens += symbol_tokens
        end
        tokens = TokenFilter::Stopword.filter(tokens, language: language)
        if enable_stemmer
          tokens = TokenFilter::Stemmer.filter(tokens, language: language)
        end
        tokens
      end
    end
  end
end
