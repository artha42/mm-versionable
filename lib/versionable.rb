require 'differ'
require 'mongo_mapper'
require 'versionable/plugins/versionable'

module VersionablePlugin
  def self.included(model)
    model.plugin Versionable
  end
end

MongoMapper::Document.append_inclusions(VersionablePlugin)
