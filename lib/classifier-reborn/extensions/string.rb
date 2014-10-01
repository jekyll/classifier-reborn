# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

require 'fast_stemmer'
require 'classifier-reborn/extensions/hasher'

module ClassifierReborn
  module CategoryNamer
    extend self
    def prepare_name(name) 
      name.to_s.gsub("_"," ").capitalize.intern 
    end
  end
end
