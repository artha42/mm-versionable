class Version
  include MongoMapper::Document

  key :data, Hash
  key :date, Time
  key :pos, Integer
  key :doc_id, String
  key :message, String
  key :updater_id, String

  ensure_index [[:doc_id, 1], [:pos, -1]]

  def content(key)
    cdata = self.data[key]
    if cdata.respond_to?(:join)
      cdata.join(" ")
    else
      cdata
    end
  end  
end
