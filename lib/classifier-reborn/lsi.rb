# frozen_string_literal: true

# Author::    David Fayram  (mailto:dfayram@lensmen.net)
# Copyright:: Copyright (c) 2005 David Fayram II
# License::   LGPL

# Try to load Numo first - it's the most current and the most well-supported.
# Fall back to GSL.
# Fall back to native vector.
begin
  raise LoadError if ENV['NATIVE_VECTOR'] == 'true' # to test the native vector class, try `rake test NATIVE_VECTOR=true`
  raise LoadError if ENV['GSL'] == 'true' # to test with gsl, try `rake test GSL=true`

  require 'numo/narray' # https://ruby-numo.github.io/narray/
  require 'numo/linalg' # https://ruby-numo.github.io/linalg/
  $SVD = :numo
rescue LoadError
  begin
    raise LoadError if ENV['NATIVE_VECTOR'] == 'true' # to test the native vector class, try `rake test NATIVE_VECTOR=true`

    require 'gsl' # requires https://github.com/SciRuby/rb-gsl
    require_relative 'extensions/vector_serialize'
    $SVD = :gsl
  rescue LoadError
    $SVD = :ruby
    require_relative 'extensions/vector'
    require_relative 'extensions/zero_vector'
  end
end

require_relative 'lsi/word_list'
require_relative 'lsi/content_node'
require_relative 'lsi/cached_content_node'
require_relative 'lsi/summarizer'
require_relative 'extensions/token_filter/stopword'
require_relative 'extensions/token_filter/symbol'

module ClassifierReborn
  # This class implements a Latent Semantic Indexer, which can search, classify and cluster
  # data based on underlying semantic relations. For more information on the algorithms used,
  # please consult Wikipedia[http://en.wikipedia.org/wiki/Latent_Semantic_Indexing].
  class LSI
    attr_reader :word_list, :cache_node_vectors
    attr_accessor :auto_rebuild

    # Create a fresh index.
    # If you want to call #build_index manually, use
    #      ClassifierReborn::LSI.new :auto_rebuild => false
    # If you want to use ContentNodes with cached vector transpositions, use
    #      lsi = ClassifierReborn::LSI.new :cache_node_vectors => true
    #
    def initialize(options = {})
      @auto_rebuild = options[:auto_rebuild] != false
      @word_list = WordList.new
      @items = {}
      @version = 0
      @built_at_version = -1
      @language = options[:language] || 'en'
      @token_filters = [
        TokenFilter::Stopword,
        TokenFilter::Symbol
      ]
      TokenFilter::Stopword.language = @language
      extend CachedContentNode::InstanceMethods if @cache_node_vectors = options[:cache_node_vectors]
    end

    # Returns true if the index needs to be rebuilt.  The index needs
    # to be built after all informaton is added, but before you start
    # using it for search, classification and cluster detection.
    def needs_rebuild?
      (@items.size > 1) && (@version != @built_at_version)
    end

    # Adds an item to the index. item is assumed to be a string, but
    # any item may be indexed so long as it responds to #to_s or if
    # you provide an optional block explaining how the indexer can
    # fetch fresh string data. This optional block is passed the item,
    # so the item may only be a reference to a URL or file name.
    #
    # For example:
    #   lsi = ClassifierReborn::LSI.new
    #   lsi.add_item "This is just plain text"
    #   lsi.add_item "/home/me/filename.txt" { |x| File.read x }
    #   ar = ActiveRecordObject.find( :all )
    #   lsi.add_item ar, *ar.categories { |x| ar.content }
    #
    def add_item(item, *categories, &block)
      clean_word_hash = Hasher.word_hash((block ? yield(item) : item.to_s),
                                         token_filters: @token_filters)
      if clean_word_hash.empty?
        puts "Input: '#{item}' is entirely stopwords or words with 2 or fewer characters. Classifier-Reborn cannot handle this document properly."
      else
        @items[item] = if @cache_node_vectors
                         CachedContentNode.new(clean_word_hash, *categories)
                       else
                         ContentNode.new(clean_word_hash, *categories)
                       end
        @version += 1
        build_index if @auto_rebuild
      end
    end

    # A less flexible shorthand for add_item that assumes
    # you are passing in a string with no categorries. item
    # will be duck typed via to_s .
    #
    def <<(item)
      add_item(item)
    end

    # Returns categories for a given indexed item. You are free to add and remove
    # items from this as you see fit. It does not invalide an index to change its categories.
    def categories_for(item)
      return [] unless @items[item]

      @items[item].categories
    end

    # Removes an item from the database, if it is indexed.
    #
    def remove_item(item)
      return unless @items.key? item

      @items.delete item
      @version += 1
    end

    # Returns an array of items that are indexed.
    def items
      @items.keys
    end

    # This function rebuilds the index if needs_rebuild? returns true.
    # For very large document spaces, this indexing operation may take some
    # time to complete, so it may be wise to place the operation in another
    # thread.
    #
    # As a rule, indexing will be fairly swift on modern machines until
    # you have well over 500 documents indexed, or have an incredibly diverse
    # vocabulary for your documents.
    #
    # The optional parameter "cutoff" is a tuning parameter. When the index is
    # built, a certain number of s-values are discarded from the system. The
    # cutoff parameter tells the indexer how many of these values to keep.
    # A value of 1 for cutoff means that no semantic analysis will take place,
    # turning the LSI class into a simple vector search engine.
    def build_index(cutoff = 0.75)
      return unless needs_rebuild?

      make_word_list

      doc_list = @items.values
      tda = doc_list.collect { |node| node.raw_vector_with(@word_list) }

      if $SVD == :numo
        tdm = Numo::NArray.asarray(tda.map(&:to_a)).transpose
        ntdm = numo_build_reduced_matrix(tdm, cutoff)

        ntdm.each_over_axis(1).with_index do |col_vec, i|
          doc_list[i].lsi_vector = col_vec
          doc_list[i].lsi_norm = col_vec / Numo::Linalg.norm(col_vec)
        end
      elsif $SVD == :gsl
        tdm = GSL::Matrix.alloc(*tda).trans
        ntdm = build_reduced_matrix(tdm, cutoff)

        ntdm.size[1].times do |col|
          vec = GSL::Vector.alloc(ntdm.column(col)).row
          doc_list[col].lsi_vector = vec
          doc_list[col].lsi_norm = vec.normalize
        end
      else
        tdm = Matrix.rows(tda).trans
        ntdm = build_reduced_matrix(tdm, cutoff)

        ntdm.column_size.times do |col|
          doc_list[col].lsi_vector = ntdm.column(col) if doc_list[col]
          if ntdm.column(col).zero?
            doc_list[col].lsi_norm = ntdm.column(col) if doc_list[col]
          else
            doc_list[col].lsi_norm = ntdm.column(col).normalize if doc_list[col]
          end
        end
      end

      @built_at_version = @version
    end

    # This method returns max_chunks entries, ordered by their average semantic rating.
    # Essentially, the average distance of each entry from all other entries is calculated,
    # the highest are returned.
    #
    # This can be used to build a summary service, or to provide more information about
    # your dataset's general content. For example, if you were to use categorize on the
    # results of this data, you could gather information on what your dataset is generally
    # about.
    def highest_relative_content(max_chunks = 10)
      return [] if needs_rebuild?

      avg_density = {}
      @items.each_key { |item| avg_density[item] = proximity_array_for_content(item).inject(0.0) { |x, y| x + y[1] } }

      avg_density.keys.sort_by { |x| avg_density[x] }.reverse[0..max_chunks - 1].map
    end

    # This function is the primitive that find_related and classify
    # build upon. It returns an array of 2-element arrays. The first element
    # of this array is a document, and the second is its "score", defining
    # how "close" it is to other indexed items.
    #
    # These values are somewhat arbitrary, having to do with the vector space
    # created by your content, so the magnitude is interpretable but not always
    # meaningful between indexes.
    #
    # The parameter doc is the content to compare. If that content is not
    # indexed, you can pass an optional block to define how to create the
    # text data. See add_item for examples of how this works.
    def proximity_array_for_content(doc, &block)
      return [] if needs_rebuild?

      content_node = node_for_content(doc, &block)
      result =
        @items.keys.collect do |item|
          val = if $SVD == :numo
                  content_node.search_vector.dot(@items[item].transposed_search_vector)
                elsif $SVD == :gsl
                  content_node.search_vector * @items[item].transposed_search_vector
                else
                  (Matrix[content_node.search_vector] * @items[item].search_vector)[0]
                end
          [item, val]
        end
      result.sort_by { |x| x[1] }.reverse
    end

    # Similar to proximity_array_for_content, this function takes similar
    # arguments and returns a similar array. However, it uses the normalized
    # calculated vectors instead of their full versions. This is useful when
    # you're trying to perform operations on content that is much smaller than
    # the text you're working with. search uses this primitive.
    def proximity_norms_for_content(doc, &block)
      return [] if needs_rebuild?

      content_node = node_for_content(doc, &block)
      if ($SVD == :gsl && content_node.raw_norm.isnan?.all?) ||
          ($SVD == :numo && content_node.raw_norm.isnan.all?)
        puts "There are no documents that are similar to #{doc}"
      else
        content_node_norms(content_node)
      end
    end

    def content_node_norms(content_node)
      result =
        @items.keys.collect do |item|
          val = if $SVD == :numo
                  content_node.search_norm.dot(@items[item].search_norm)
                elsif $SVD == :gsl
                  content_node.search_norm * @items[item].search_norm.col
                else
                  (Matrix[content_node.search_norm] * @items[item].search_norm)[0]
                end
          [item, val]
        end
      result.sort_by { |x| x[1] }.reverse
    end

    # This function allows for text-based search of your index. Unlike other functions
    # like find_related and classify, search only takes short strings. It will also ignore
    # factors like repeated words. It is best for short, google-like search terms.
    # A search will first priortize lexical relationships, then semantic ones.
    #
    # While this may seem backwards compared to the other functions that LSI supports,
    # it is actually the same algorithm, just applied on a smaller document.
    def search(string, max_nearest = 3)
      return [] if needs_rebuild?

      carry = proximity_norms_for_content(string)
      unless carry.nil?
        result = carry.collect { |x| x[0] }
        result[0..max_nearest - 1]
      end
    end

    # This function takes content and finds other documents
    # that are semantically "close", returning an array of documents sorted
    # from most to least relavant.
    # max_nearest specifies the number of documents to return. A value of
    # 0 means that it returns all the indexed documents, sorted by relavence.
    #
    # This is particularly useful for identifing clusters in your document space.
    # For example you may want to identify several "What's Related" items for weblog
    # articles, or find paragraphs that relate to each other in an essay.
    def find_related(doc, max_nearest = 3, &block)
      carry =
        proximity_array_for_content(doc, &block).reject { |pair| pair[0].eql? doc }
      result = carry.collect { |x| x[0] }
      result[0..max_nearest - 1]
    end

    # Return the most obvious category with the score
    def classify_with_score(doc, cutoff = 0.30, &block)
      scored_categories(doc, cutoff, &block).last
    end

    # Return the most obvious category without the score
    def classify(doc, cutoff = 0.30, &block)
      scored_categories(doc, cutoff, &block).last.first
    end

    # This function uses a voting system to categorize documents, based on
    # the categories of other documents. It uses the same logic as the
    # find_related function to find related documents, then returns the
    # list of sorted categories.
    #
    # cutoff signifies the number of documents to consider when clasifying
    # text. A cutoff of 1 means that every document in the index votes on
    # what category the document is in. This may not always make sense.
    #
    def scored_categories(doc, cutoff = 0.30, &block)
      icutoff = (@items.size * cutoff).round
      carry = proximity_array_for_content(doc, &block)
      carry = carry[0..icutoff - 1]
      votes = Hash.new(0.0)
      carry.each do |pair|
        @items[pair[0]].categories.each do |category|
          votes[category] += pair[1]
        end
      end

      votes.sort_by { |_, score| score }
    end

    # Prototype, only works on indexed documents.
    # I have no clue if this is going to work, but in theory
    # it's supposed to.
    def highest_ranked_stems(doc, count = 3)
      raise 'Requested stem ranking on non-indexed content!' unless @items[doc]

      content_vector_array = node_for_content(doc).lsi_vector.to_a
      top_n = content_vector_array.sort.reverse[0..count - 1]
      top_n.collect { |x| @word_list.word_for_index(content_vector_array.index(x)) }
    end

    def reset
      initialize(auto_rebuild: @auto_rebuild, cache_node_vectors: @cache_node_vectors)
    end

    private

    def build_reduced_matrix(matrix, cutoff = 0.75)
      # TODO: Check that M>=N on these dimensions! Transpose helps assure this
      u, v, s = matrix.SV_decomp
      # TODO: Better than 75% term, please. :\
      s_cutoff = s.sort.reverse[(s.size * cutoff).round - 1]
      s.size.times do |ord|
        s[ord] = 0.0 if s[ord] < s_cutoff
      end
      # Reconstruct the term document matrix, only with reduced rank
      u * ($SVD == :gsl ? GSL::Matrix : ::Matrix).diag(s) * v.trans
    end

    def numo_build_reduced_matrix(matrix, cutoff = 0.75)
      s, u, vt = Numo::Linalg.svd(matrix, driver: 'svd', job: 'S')

      # TODO: Better than 75% term (as above)
      s_cutoff = s.sort.reverse[(s.size * cutoff).round - 1]
      s.size.times do |ord|
        s[ord] = 0.0 if s[ord] < s_cutoff
      end

      # Reconstruct the term document matrix, only with reduced rank
      u.dot(::Numo::DFloat.eye(s.size) * s).dot(vt)
    end

    def node_for_content(item, &block)
      if @items[item]
        return @items[item]
      else
        clean_word_hash = Hasher.word_hash((block ? yield(item) : item.to_s),
                                           token_filters: @token_filters)

        content_node = ContentNode.new(clean_word_hash, &block) # make the node and extract the data

        unless needs_rebuild?
          content_node.raw_vector_with(@word_list) # make the lsi raw and norm vectors
        end
      end

      content_node
    end

    def make_word_list
      @word_list = WordList.new
      @items.each_value do |node|
        node.word_hash.each_key { |key| @word_list.add_word(key) }
      end
    end
  end
end
