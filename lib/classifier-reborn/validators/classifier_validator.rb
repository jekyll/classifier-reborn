module ClassifierReborn
  module ClassifierValidator

    module_function

    def evaluate(classifier, test_data)
      conf_mat = Hash.new { |h, k| h[k] = {} }
      categories = classifier.categories
      categories.each do |actual|
        categories.each do |predicted|
          conf_mat[actual][predicted] = 0
        end
      end
      test_data.each do |rec|
        predicted = classifier.classify(rec.last)
        conf_mat[rec.first.tr('_', ' ').capitalize][predicted] += 1 unless predicted.nil?
      end
      conf_mat
    end

    def validate(classifier, training_data, test_data)
      classifier.reset()
      training_data.each do |rec|
        classifier.train(rec.first, rec.last)
      end
      evaluate(classifier, test_data)
    end

    def cross_validate(classifier, sample_data, fold=10, *options)
      classifier = ClassifierReborn::const_get(classifier).new(options) if classifier.is_a?(String)
      sample_data.shuffle!
      partition_size = sample_data.length / fold
      partitioned_data = sample_data.each_slice(partition_size)
      conf_mats = []
      fold.times do |i|
        training_data = partitioned_data.take(fold)
        test_data = training_data.slice!(i)
        conf_mats << validate(classifier, training_data.flatten!(1), test_data)
      end
      classifier.reset()
      generate_stats(conf_mats)
    end

    def generate_stats(*conf_mats)
      pp *conf_mats
      # Derive various statistics for one or more supplied confusion matrices
      # Report summary based on individual and accumulated confusion matrices
    end
  end
end
