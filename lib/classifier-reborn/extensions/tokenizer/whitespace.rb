# encoding: utf-8
# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module ClassifierReborn
  module Tokenizer
    module Whitespace
      module_function

      def tokenize(str)
        str.gsub(/[^\p{WORD}\s]/, '').downcase.split
      end
    end
  end
end
