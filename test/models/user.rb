class User
  include MongoMapper::Document

  enable_versioning :limit => 20

  key :fname, String
  key :lname, String
  key :email, String
  key :address, String

  many :posts
end
