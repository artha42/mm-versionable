require 'rubygems'
require 'rake'

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

desc 'Builds the gem'
task :build do
  sh 'gem build phr_repo.gemspec'
    Dir.mkdir('pkg') unless File.directory?('pkg')
      sh "mv phr_repo-#{HealthHiway::Version}.gem pkg/phr_repo-#{HealthHiway::Version}.gem"
end

desc 'Builds and Installs the gem'
task :install => :build do
  sh "gem install pkg/phr_repo-#{HealthHiway::Version}.gem"
end
