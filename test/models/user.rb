class User
  include MongoMapper::Document

  attr_accessible :fname, :lname, :email

  enable_versioning :limit => 20

  key :fname, String
  key :lname, String
  key :email, String
  key :address, String

  many :posts
end
