# encoding: utf-8
# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module ClassifierReborn
  module TokenFilter
    # This filter converts given tokens to their stemmed versions in the language.
    module Stemmer
      module_function

      def filter(tokens, language: 'en')
        tokens.collect do |token|
          if token.stemmable?
            token.stem
          else
            token
          end
        end
      end
    end
  end
end
