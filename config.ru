$LOAD_PATH.unshift(".") unless $LOAD_PATH.include?(".") 

require 'pp'
require 'rubygems'

$:.unshift(::File.join(::File.expand_path('.'), '/lib'))
require 'versionable.rb'

require 'test/config/config'
require 'test/models/post'
require 'test/models/user'
