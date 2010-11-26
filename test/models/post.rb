class Post
  include MongoMapper::EmbeddedDocument
  
  key :date, Time
  key :body, String
  key :title, String

end
