# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'classifier-reborn/version'

Gem::Specification.new do |s|
  s.platform = 'java'
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '2.2.2'
  s.required_ruby_version = '>= 1.9.3'

  s.name             = 'classifier-reborn'
  s.version          = ClassifierReborn::VERSION
  s.license          = 'LGPL'
  s.summary          = 'A general classifier module to allow Bayesian and other types of classifications.'
  s.authors          = ['Lucas Carlson', 'Parker Moore', 'Chase Gilliam']
  s.email            = ['lucas@rufy.com', 'parkrmoore@gmail.com', 'chase.gilliam@gmail.com']
  s.homepage         = 'https://github.com/jekyll/classifier-reborn'

  all_files          = `git ls-files -z`.split("\x0")
  s.files            = all_files.grep(%r{^(bin|lib|data)/})
  s.executables      = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths    = ['lib']

  s.has_rdoc         = true
  s.rdoc_options     = ['--charset=UTF-8']
  s.extra_rdoc_files = %w(README.markdown LICENSE)

  s.add_runtime_dependency('jruby-stemmer', '~> 0.0.1')

  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('minitest')
  s.add_development_dependency('minitest-reporters')
  s.add_development_dependency('rubocop')
  s.add_development_dependency('pry')
  s.add_development_dependency('redis')
end
