$LOAD_PATH.unshift('.') unless $LOAD_PATH.include?('.')

require File.expand_path(File.dirname(__FILE__) + '/../lib/versionable')

require 'pp'
require 'shoulda'

require 'test/models/user'

require 'config/config'

User.delete_all
u = User.create(:fname => 'dhruva', :lname => 'sagar', :email => 'dhruva.sagar@gmail.com')
u.fname = 'Dhruva'
u.lname = 'Sagar'
u.save
