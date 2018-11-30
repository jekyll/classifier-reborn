module TestDataLoader
  def self.sms_data
    @@sms_data ||= load_sms_data
  end

  def self.load_sms_data
    sms_spam_collection = File.expand_path(File.dirname(__FILE__) + '/corpus/SMSSpamCollection.tsv')
    File.read(sms_spam_collection).force_encoding('utf-8').split("\n")
  end

  def self.report_insufficient_data(available, required)
    puts "\e[31mInsufficient records in the dataset: available #{available}, required #{required}\e[0m"
  end
end
