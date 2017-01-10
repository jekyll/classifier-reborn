# encoding: utf-8

module TestDataLoader
  def self.sms_data
    @@sms_data ||= self.load_sms_data
  end

  def self.load_sms_data
    sms_spam_collection = File.expand_path(File.dirname(__FILE__) + '/corpus/SMSSpamCollection.tsv')
    File.read(sms_spam_collection).force_encoding("utf-8").split("\n")
  end
end

#     puts "\n\e[31mInsufficient records in the dataset: available #{lines.length}, required #{MAX_RECORDS}\e[0m\n\n" if lines.length < MAX_RECORDS
#    lines
