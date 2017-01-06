require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'bundler/gem_tasks'
require 'thermite/tasks'

desc 'Default Task'
task default: [:test]

# Run the Thermite Rust tasks
Thermite::Tasks.new

# Run the unit tests
desc 'Run all unit tests'
Rake::TestTask.new('test') do |t|
  t.libs << 'lib'
  t.pattern = 'test/*/*_test.rb'
  t.verbose = true
end

# Make a console, useful when working on tests
desc 'Generate a test console'
task :console do
  verbose(false) { sh "irb -I lib/ -r 'classifier-reborn'" }
end

# Genereate the RDoc documentation
desc 'Create documentation'
Rake::RDocTask.new('doc') do |rdoc|
  rdoc.title = 'Ruby Classifier - Bayesian and LSI classification library'
  rdoc.rdoc_dir = 'html'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
