# encoding: utf-8
# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

require 'set'

module ClassifierReborn
  module Hasher
    STOPWORDS_PATH = [File.expand_path(File.dirname(__FILE__) + '/../../../data/stopwords')]

    module_function

    # Return a Hash of strings => ints. Each word in the string is stemmed,
    # interned, and indexes to its frequency in the document.
    def word_hash(str, language = 'en', enable_stemmer = true)
      cleaned_word_hash = clean_word_hash(str, language, enable_stemmer)
      symbol_hash = word_hash_for_symbols(str.scan(/[^\s\p{WORD}]/))
      cleaned_word_hash.merge(symbol_hash)
    end

    # Return a word hash without extra punctuation or short symbols, just stemmed words
    def clean_word_hash(str, language = 'en', enable_stemmer = true)
      word_hash_for_words(str.gsub(/[^\p{WORD}\s]/, '').downcase.split, language, enable_stemmer)
    end

    def word_hash_for_words(words, language = 'en', enable_stemmer = true)
      d = Hash.new(0)
      words.each do |word|
        next unless word.length > 2 && !STOPWORDS[language].include?(word)
        if enable_stemmer
          d[word.stem.intern] += 1
        else
          d[word.intern] += 1
        end
      end
      d
    end

    # Add custom path to a new stopword file created by user
    def add_custom_stopword_path(path)
      STOPWORDS_PATH.unshift(path)
    end

    def word_hash_for_symbols(words)
      d = Hash.new(0)
      words.each do |word|
        d[word.intern] += 1
      end
      d
    end

    # Create a lazily-loaded hash of stopword data
    STOPWORDS = Hash.new do |hash, language|
      hash[language] = []

      STOPWORDS_PATH.each do |path|
        if File.exist?(File.join(path, language))
          hash[language] = Set.new File.read(File.join(path, language.to_s)).force_encoding("utf-8").split
          break
        end
      end

      hash[language]
    end
  end
end
