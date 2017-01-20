module ClassifierReborn
  module ClassifierValidator

    module_function

    def evaluate(classifier, test_data)
      conf_mat = empty_conf_mat(classifier.categories.sort)
      test_data.each do |rec|
        actual = rec.first.tr('_', ' ').capitalize
        predicted = classifier.classify(rec.last)
        conf_mat[actual][predicted] += 1 unless predicted.nil?
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
      pp conf_mats.flatten!
      accumulated_conf_mat = conf_mats.length == 1 ? conf_mats.first : empty_conf_mat(conf_mats.first.keys.sort)
      header = "Run     Total   Correct Incorrect  Accuracy"
      puts
      puts " Stats ".center(43, "-")
      puts header
      puts "-" * header.length

      if conf_mats.length > 1
        conf_mats.each_with_index do |conf_mat, i|
          stats = calculate_stats(conf_mat)
          print_stats(stats, i+1)

          conf_mat.each do |actual, cols|
            cols.each do |predicted, v|
              accumulated_conf_mat[actual][predicted] += v
            end
          end
        end
        puts "-" * header.length
      end
      stats = calculate_stats(accumulated_conf_mat)
      print_stats(stats, "All")
      puts
    end

    def calculate_stats(conf_mat)
      correct = incorrect = 0
      conf_mat.each do |actual, cols|
        cols.each do |predicted, v|
          if actual == predicted
            correct += v
          else
            incorrect += v
          end
        end  
      end
      total = correct + incorrect
      accuracy = total.zero? ? 0 : correct / total.to_f
      {total: total, correct: correct, incorrect: incorrect, accuracy: accuracy}
    end

    def print_stats(stats, prefix="")
      puts "#{prefix.to_s.rjust(3)} #{stats[:total].to_s.rjust(9)} #{stats[:correct].to_s.rjust(9)} #{stats[:incorrect].to_s.rjust(9)} #{stats[:accuracy].round(5).to_s.ljust(7, '0').rjust(9)}"
    end

    def empty_conf_mat(categories)
      categories.map{|actual| [actual, categories.map{|predicted| [predicted, 0]}.to_h]}.to_h
    end
  end
end
