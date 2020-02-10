# frozen_string_literal: true

# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module ClassifierReborn
  module TokenFilter
    # This filter removes stopwords in the language, from given tokens.
    module Stopword
      STOPWORDS_PATH = [File.expand_path(File.dirname(__FILE__) + '/../../../../data/stopwords')]
      @language = 'en'

      module_function

      def call(tokens)
        tokens.reject do |token|
          token.maybe_stopword? &&
            (token.length <= 2 || STOPWORDS[@language].include?(token))
        end
      end

      # Add custom path to a new stopword file created by user
      def add_custom_stopword_path(path)
        STOPWORDS_PATH.unshift(path)
      end

      # Create a lazily-loaded hash of stopword data
      STOPWORDS = Hash.new do |hash, language|
        hash[language] = []

        STOPWORDS_PATH.each do |path|
          if File.exist?(File.join(path, language))
            hash[language] = Set.new File.read(File.join(path, language.to_s)).force_encoding('utf-8').split
            break
          end
        end

        hash[language]
      end

      # Changes the language of stopwords
      def language=(language)
        @language = language
      end
    end
  end
end
