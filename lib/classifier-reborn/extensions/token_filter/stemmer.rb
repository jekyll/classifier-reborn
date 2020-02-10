# frozen_string_literal: true

# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module ClassifierReborn
  module TokenFilter
    # This filter converts given tokens to their stemmed versions.
    module Stemmer
      module_function

      def call(tokens)
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
