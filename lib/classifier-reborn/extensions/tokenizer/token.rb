# encoding: utf-8
# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module ClassifierReborn
  module Tokenizer
    class Token < String
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
