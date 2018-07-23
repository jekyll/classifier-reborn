module DataHandler
  # Read the data and populate the backend in use
  def import!(data)
    data[:categories].keys.each { |category| add_category(category) }
    categories = data[:categories]
    categories.each_key do |category|
      categories[category].each do |word, diff|
        update_category_word_frequency(category, word, diff)
      end
    end
    update_total_words(data[:total_words])
  end

  def export
    {
      categories: @categories,
      category_counts: @category_counts,
      category_word_count: @category_word_count,
      total_words: @total_words
    }
  end
end
