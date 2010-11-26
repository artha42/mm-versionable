require 'rubygems'
require 'rake'
require 'jeweler'

require File.join(File.dirname(__FILE__), '/lib/versionable/version')

require 'rake/testtask'
namespace :test do
  Rake::TestTask.new(:units) do |test|
    test.libs << 'test'
    test.ruby_opts << '-rubygems'
    test.pattern = 'test/unit/**/test_*.rb'
    test.verbose = true 
  end

  Rake::TestTask.new(:performance) do |test|
    test.libs << 'test'
    test.ruby_opts << '-rubygems'
    test.pattern = 'test/performance/**/*.rb'
    test.verbose = true 
  end
end

task :default => 'test:units'

Jeweler::Tasks.new do |gem|
  gem.name          = 'mongomapper-versionable'
  gem.summary       = 'A MongoMapper extension for document versioning'
  gem.description   = 'A MongoMapper extension that enables document versionable'
  gem.email         = 'dhruva.sagar@gmail.com'
  gem.homepage      = 'http://github.com/dhruvasagar/mongomapper-versionable'
  gem.authors       = ['Dhruva Sagar']
  gem.version       = Versionable::Version

  gem.add_dependency('differ')
  gem.add_dependency('mongo_mapper')
end

Jeweler::GemcutterTasks.new
