require File.expand_path(File.dirname(__FILE__) + '/../../lib/versionable')

require 'benchmark'

MongoMapper.database = 'versionable_performance'
 
class Foo
  include MongoMapper::Document

  enable_versioning

  key :approved, Boolean
  key :count, Integer
  key :approved_at, Time
  key :expire_on, Date
end
Foo.collection.remove

class Bar
  include MongoMapper::Document

  key :approved, Boolean
  key :count, Integer
  key :approved_at, Time
  key :expire_on, Date
end
Bar.collection.remove

Benchmark.bm(22) do |x|
  ids = []
  x.report("write with versioning   ") do
    1000.times { |i| ids << Foo.create(:count => 0, :approved => true, :approved_at => Time.now, :expire_on => Date.today).id }
  end
  x.report("write without versioning") do
    1000.times { |i| ids << Bar.create(:count => 0, :approved => true, :approved_at => Time.now, :expire_on => Date.today).id }
  end
  x.report("read with versioning    ") do
    ids.each { |id| Foo.first(:id => id) }
  end
  x.report("read without versioning ") do
    ids.each { |id| Bar.first(:id => id) }
  end
end
