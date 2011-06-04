require 'differ'
require 'mongo_mapper'
require 'versionable/plugins/versionable'

MongoMapper::Document.plugin(Versionable)
