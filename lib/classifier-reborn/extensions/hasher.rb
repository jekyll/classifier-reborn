# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

require "set"

module ClassifierReborn
  module Hasher
    extend self

    # Removes common punctuation symbols, returning a new string.
    # E.g.,
    #   "Hello (greeting's), with {braces} < >...?".without_punctuation
    #   => "Hello  greetings   with  braces         "
    def without_punctuation(str)
      str .tr( ',?.!;:"@#$%^&*()_=+[]{}\|<>/`~', " " ) .tr( "'\-", "")
    end

    # Return a Hash of strings => ints. Each word in the string is stemmed,
    # interned, and indexes to its frequency in the document.
    def word_hash(str)
      word_hash   = clean_word_hash(str)
      symbol_hash = word_hash_for_symbols(str.gsub(/[\w]/," ").split)
      return clean_word_hash(str).merge(symbol_hash)
    end

    # Return a word hash without extra punctuation or short symbols, just stemmed words
    def clean_word_hash(str)
      word_hash_for_words str.gsub(/[^\w\s]/,"").split
    end

    def word_hash_for_words(words)
      d = Hash.new(0)
      words.each do |word|
        word.downcase!
        if ! CORPUS_SKIP_WORDS.include?(word) && word.length > 2
          d[word.stem.intern] += 1
        end
      end
      return d
    end

    def word_hash_for_symbols(words)
      d = Hash.new(0)
      words.each do |word|
        d[word.intern] += 1
      end
      return d
    end

    CORPUS_SKIP_WORDS = Set.new(%w[
      a
      again
      all
      along
      are
      also
      an
      and
      as
      at
      but
      by
      came
      can
      cant
      couldnt
      did
      didn
      didnt
      do
      doesnt
      dont
      ever
      first
      from
      have
      her
      here
      him
      how
      i
      if
      in
      into
      is
      isnt
      it
      itll
      just
      last
      least
      like
      most
      my
      new
      no
      not
      now
      of
      on
      or
      should
      sinc
      so
      some
      th
      than
      this
      that
      the
      their
      then
      those
      to
      told
      too
      true
      try
      until
      url
      us
      were
      when
      whether
      while
      with
      within
      yes
      you
      youll
    ])
  end
end
