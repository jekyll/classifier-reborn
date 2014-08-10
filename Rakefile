require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'

desc "Default Task"
task :default => [ :test ]

# Run the unit tests
desc "Run all unit tests"
Rake::TestTask.new("test") { |t|
  t.libs << "lib"
  t.pattern = 'test/*/*_test.rb'
  t.verbose = true
}

# Make a console, useful when working on tests
desc "Generate a test console"
task :console do
   verbose( false ) { sh "irb -I lib/ -r 'classifier-reborn'" }
end

# Genereate the RDoc documentation
desc "Create documentation"
Rake::RDocTask.new("doc") { |rdoc|
  rdoc.title = "Ruby Classifier - Bayesian and LSI classification library"
  rdoc.rdoc_dir = 'html'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
}

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  require 'code_statistics/code_statistics'
  puts CodeStatistics::CodeStatistics.new([
    ["Library", "lib"],
    ["Units", "test"]
  ]).to_s
end
