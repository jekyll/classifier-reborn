# frozen_string_literal: true

# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

require_relative 'token'

module ClassifierReborn
  module Tokenizer
    # This tokenizes given input as white-space separated terms.
    # It mainly aims to tokenize sentences written with a space between words, like English, French, and others.
    module Whitespace
      module_function

      def call(str)
        tokens = str.gsub(/[^\p{WORD}\s]/, '').downcase.split.collect do |word|
          Token.new(word, stemmable: true, maybe_stopword: true)
        end
        symbol_tokens = str.scan(/[^\s\p{WORD}]/).collect do |word|
          Token.new(word, stemmable: false, maybe_stopword: false)
        end
        tokens += symbol_tokens
        tokens
      end
    end
  end
end
