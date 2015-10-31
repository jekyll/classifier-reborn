# Author::    Kelley Reynolds  (mailto:kelley@insidesystems.net)
# Copyright:: Copyright (c) 2015 Kelley Reynolds
# License::   LGPL

module ClassifierReborn
  # Subclass of ContentNode which caches the search_vector transpositions.
  # Its great because its much faster for large indexes, but at the cost of more ram. Additionally,
  # if you Marshal your classifier and want to keep the size down, you'll need to manually
  # clear the cache before you dump
  class CachedContentNode < ContentNode
    module InstanceMethods
      # Go through each item in this index and clear the cache
      def clear_cache!
        @items.each_value(&:clear_cache!)
      end
    end

    def initialize(word_hash, *categories)
      clear_cache!
      super
    end

    def clear_cache!
      @transposed_search_vector = nil
    end

    # Cache the transposed vector, it gets used a lot
    def transposed_search_vector
      @transposed_search_vector ||= super
    end

    # Clear the cache before we continue on
    def raw_vector_with(word_list)
      clear_cache!
      super
    end

    # We don't want the cached_data here
    def marshal_dump
      [@lsi_vector, @lsi_norm, @raw_vector, @raw_norm, @categories, @word_hash]
    end

    def marshal_load(array)
      @lsi_vector, @lsi_norm, @raw_vector, @raw_norm, @categories, @word_hash = array
    end
  end
end
