require File.expand_path(File.dirname(__FILE__) + '/../../lib/versionable')

require 'benchmark'

MongoMapper.database = 'versionable_performance'
 
class Foo
  include MongoMapper::Document
  plugin Versionable

  enable_versioning

  key :approved, Boolean
  key :count, Integer
  key :approved_at, Time
  key :expire_on, Date
end
Foo.collection.remove

Benchmark.bm(5) do |x|
  ids = []
  hhids = []
  x.report("write   ") do
    1000.times { |i| ids << Foo.create(:count => 0, :approved => true, :approved_at => Time.now, :expire_on => Date.today).id }
  end
  x.report("read    ") do
    ids.each { |id| Foo.first(:id => id) }
  end
end
