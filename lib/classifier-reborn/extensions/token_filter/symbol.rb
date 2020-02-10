# frozen_string_literal: true

# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module ClassifierReborn
  module TokenFilter
    # This filter removes symbol-only terms, from given tokens.
    module Symbol
      module_function

      def call(tokens)
        tokens.reject do |token|
          /[^\s\p{WORD}]/ === token
        end
      end
    end
  end
end
