$LOAD_PATH.unshift('.') unless $LOAD_PATH.include?('.')

require 'test/config/config'
require File.expand_path(File.dirname(__FILE__) + '/../lib/versionable')

require 'pp'
require 'shoulda'

require 'test/models/post'
require 'test/models/user'

User.delete_all
u = User.create(:fname => 'dhruva', :lname => 'sagar', :email => 'dhruva.sagar@gmail.com')
u.fname = 'Dhruva'
u.lname = 'Sagar'
u.save

u.posts << Post.new(:title => 'Dummy title', :body => 'Dummy post body', :date => Time.now)
u.save
