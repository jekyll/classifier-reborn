# frozen_string_literal: true

# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module ClassifierReborn
  module Tokenizer
    class Token < String
      # The class can be created with one token string and extra attributes. E.g.,
      #      t = ClassifierReborn::Tokenizer::Token.new 'Tokenize', stemmable: true, maybe_stopword: false
      #
      # Attributes available are:
      #   stemmable:        true  Possibility that the token can be stemmed. This must be false for un-stemmable terms, otherwise this should be true.
      #   maybe_stopword:   true  Possibility that the token is a stopword. This must be false for terms which never been stopword, otherwise this should be true.
      def initialize(string, stemmable: true, maybe_stopword: true)
        super(string)
        @stemmable = stemmable
        @maybe_stopword = maybe_stopword
      end

      def stemmable?
        @stemmable
      end

      def maybe_stopword?
        @maybe_stopword
      end

      def stem
        stemmed = super
        self.class.new(stemmed, stemmable: @stemmable, maybe_stopword: @maybe_stopword)
      end
    end
  end
end
