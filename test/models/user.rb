class User
  include MongoMapper::Document
  plugin Versionable

  key :fname, String
  key :lname, String
  key :email, String
  key :address, String

  many :posts
end
