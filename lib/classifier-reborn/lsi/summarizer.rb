# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module ClassifierReborn
  module Summarizer
    module_function

    def summary(str, count = 10, separator = ' [...] ')
      perform_lsi split_sentences(str), count, separator
    end

    def paragraph_summary(str, count = 1, separator = ' [...] ')
      perform_lsi split_paragraphs(str), count, separator
    end

    def split_sentences(str)
      str.split(/(\.|\!|\?)/) # TODO: make this less primitive
    end

    def split_paragraphs(str)
      str.split(/(\n\n|\r\r|\r\n\r\n)/) # TODO: make this less primitive
    end

    def perform_lsi(chunks, count, separator)
      lsi = ClassifierReborn::LSI.new auto_rebuild: false
      chunks.each { |chunk| lsi << chunk unless chunk.strip.empty? || chunk.strip.split.size == 1 }
      lsi.build_index
      summaries = lsi.highest_relative_content count
      summaries.reject { |chunk| !summaries.include? chunk }.map(&:strip).join(separator)
    end
  end
end
