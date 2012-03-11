# encoding: UTF-8
require File.join File.dirname(__FILE__), '/lib/versionable/version'

Gem::Specification.new do |s|
  s.name                          = 'mm-versionable'
  s.homepage                      = 'http://github.com/dhruvasagar/mm-versionable'
  s.summary                       = 'A MongoMapper extension adding Versioning'
  s.require_paths                 = ['lib']
  s.authors                       = ['Dhruva Sagar']
  s.email                         = 'dhruva.sagar@gmail.com'
  s.version                       = Versionable::VERSION
  s.platform                      = Gem::Platform::RUBY
  s.files                         = Dir.glob('lib/**/*') + %w[config.ru Gemfile Rakefile README.md]
  s.test_files                    = Dir.glob('test/**/*')

  s.add_dependency 'i18n'
  s.add_dependency 'differ'
  s.add_dependency 'builder'
  s.add_dependency 'bson'
  s.add_dependency 'mongo_mapper', '>= 0.9.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'ruby-debug19'
end
