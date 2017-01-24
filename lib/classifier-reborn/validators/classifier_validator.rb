module ClassifierReborn
  module ClassifierValidator

    module_function

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
      generate_report(conf_mats)
    end

    def validate(classifier, training_data, test_data, *options)
      classifier = ClassifierReborn::const_get(classifier).new(options) if classifier.is_a?(String)
      classifier.reset()
      training_data.each do |rec|
        classifier.train(rec.first, rec.last)
      end
      evaluate(classifier, test_data)
    end

    def evaluate(classifier, test_data)
      conf_mat = empty_conf_mat(classifier.categories.sort)
      test_data.each do |rec|
        actual = rec.first.tr('_', ' ').capitalize
        predicted = classifier.classify(rec.last)
        conf_mat[actual][predicted] += 1 unless predicted.nil?
      end
      conf_mat
    end

    def generate_report(*conf_mats)
      conf_mats.flatten!
      accumulated_conf_mat = conf_mats.length == 1 ? conf_mats.first : empty_conf_mat(conf_mats.first.keys.sort)
      header = "Run     Total   Correct Incorrect  Accuracy"
      puts
      puts " Run Report ".center(header.length, "-")
      puts header
      puts "-" * header.length
      if conf_mats.length > 1
        conf_mats.each_with_index do |conf_mat, i|
          run_report = build_run_report(conf_mat)
          print_run_report(run_report, i+1)
          conf_mat.each do |actual, cols|
            cols.each do |predicted, v|
              accumulated_conf_mat[actual][predicted] += v
            end
          end
        end
        puts "-" * header.length
      end
      run_report = build_run_report(accumulated_conf_mat)
      print_run_report(run_report, "All")
      puts
      print_conf_mat(accumulated_conf_mat)
      puts
      conf_tab = conf_mat_to_tab(accumulated_conf_mat)
      print_conf_tab(conf_tab)
    end

    def build_run_report(conf_mat)
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
      {total: total, correct: correct, incorrect: incorrect, accuracy: divide(correct, total)}
    end

    def conf_mat_to_tab(conf_mat)
      conf_tab = Hash.new {|h, k| h[k] = {p: {t: 0, f: 0}, n: {t: 0, f: 0}}}
      conf_mat.each_key do |positive|
        conf_mat.each do |actual, cols|
          cols.each do |predicted, v|
            conf_tab[positive][positive == predicted ? :p : :n][actual == predicted ? :t : :f] += v
          end
        end
      end
      conf_tab
    end

    def print_run_report(stats, prefix="", print_header=false)
      puts "#{"Run".rjust([3, prefix.length].max)}     Total   Correct Incorrect  Accuracy" if print_header
      puts "#{prefix.to_s.rjust(3)} #{stats[:total].to_s.rjust(9)} #{stats[:correct].to_s.rjust(9)} #{stats[:incorrect].to_s.rjust(9)} #{stats[:accuracy].round(5).to_s.ljust(7, '0').rjust(9)}"
    end

    def print_conf_mat(conf_mat)
      header = ["Predicted ->"] + conf_mat.keys + ["Total", "Recall"]
      cell_size = header.map(&:length).max
      header = header.map{|h| h.rjust(cell_size)}.join(" ")
      puts " Confusion Matrix ".center(header.length, "-")
      puts header
      puts "-" * header.length
      predicted_totals = conf_mat.keys.map{|predicted| [predicted, 0]}.to_h
      correct = 0
      conf_mat.each do |k, rec|
        actual_total = rec.values.reduce(:+)
        puts ([k.ljust(cell_size)] + rec.values.map{|v| v.to_s.rjust(cell_size)} + [actual_total.to_s.rjust(cell_size), divide(rec[k], actual_total).round(5).to_s.rjust(cell_size)]).join(" ")
        rec.each do |cat, val|
          predicted_totals[cat] += val
          correct += val if cat == k
        end
      end
      total = predicted_totals.values.reduce(:+)
      puts "-" * header.length
      puts (["Total".ljust(cell_size)] + predicted_totals.values.map{|v| v.to_s.rjust(cell_size)} + [total.to_s.rjust(cell_size), "".rjust(cell_size)]).join(" ")
      puts (["Precision".ljust(cell_size)] + predicted_totals.keys.map{|k| divide(conf_mat[k][k], predicted_totals[k]).round(5).to_s.rjust(cell_size)} + ["Accuracy ->".rjust(cell_size), divide(correct, total).round(5).to_s.rjust(cell_size)]).join(" ")
    end

    def print_conf_tab(conf_tab)
      conf_tab.each do |positive, tab|
        puts "# Positive class: #{positive}"
        derivations = conf_tab_derivations(tab)
        print_derivations(derivations)
        puts
      end
    end

    def conf_tab_derivations(tab)
      positives = tab[:p][:t] + tab[:n][:f]
      negatives = tab[:n][:t] + tab[:p][:f]
      total     = positives + negatives
      {
        total_population:   positives + negatives,
        condition_positive: positives,
        condition_negative: negatives,
        true_positive:      tab[:p][:t],
        true_negative:      tab[:n][:t],
        false_positive:     tab[:p][:f],
        false_negative:     tab[:n][:f],
        prevalence:         divide(positives, total),
        specificity:        divide(tab[:n][:t], negatives),
        recall:             divide(tab[:p][:t], positives),
        precision:          divide(tab[:p][:t], tab[:p][:t] + tab[:p][:f]),
        accuracy:           divide(tab[:p][:t] + tab[:n][:t], total),
        f1_score:           divide(2 * tab[:p][:t], 2 * tab[:p][:t] + tab[:p][:f] + tab[:n][:f])
      }
    end

    def print_derivations(derivations)
      max_len = derivations.keys.map(&:length).max
      derivations.each do |k, v|
        puts k.to_s.tr('_', ' ').capitalize.ljust(max_len) + " : " + v.to_s
      end
    end

    def empty_conf_mat(categories)
      categories.map{|actual| [actual, categories.map{|predicted| [predicted, 0]}.to_h]}.to_h
    end

    def divide(dividend, divisor)
      divisor.zero? ? 0.0 : dividend / divisor.to_f
    end
  end
end
