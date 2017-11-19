# encoding: utf-8
# Author::    David Stancu  (mailto:dstancu@nyu.edu)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module ClassifierReborn
  class Stemmer
    include Singleton

    def stem(str)
      case ENV['RUBY_PLATFORM']
      when 'java'
        jruby_stemmer.stem(str)
      else
        str.stem
      end
    end

    private

    def jruby_stemmer
      @jruby_stemmer ||= JRuby::Stemmer
    end
  end
end
