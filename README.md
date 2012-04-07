MongoMapper Versioning
======================
A MongoMapper plugin which enables document versioning.

Install
-------
$ gem install mm-versionable

Note on Patches/Pull Requests
-----------------------------
* Fork the project
* Make your feature addition or bug fix.
* Add tests for it. This is critical so that things dont break unintentionally.
* Commit, do not make any changes in the rakefile, version, or history. (If you want to have your own version, that is fine but bump the version in a commit by itself so I can ignore it when I pull)
* Send me a pull request.

Usage
-----
The following example should demonstrate how to use versioning well :

    require 'mongo_mapper'
    require 'versionable' # gem 'mm-versionable', :require => 'versionable' -- Put this in your Gemfile if you're using bundler

    class Thing
        include MongoMapper::Document

        enable_versioning :limit => 20
        #:limit here defines the size of the version history that will be loaded into memory,
        #By default, if not specified, the value is 10, if you wish to load all versions set it to 0

        key :name, String, :required => true
        key :date, Time
    end

    thing = Thing.create(:name => 'Dhruva Sagar', :date => Time.now)

    thing.name = 'Change Thing'
    thing.save

    #Alternatively you can also pass in a "updater_id" to the save method which will be saved within the version, this can be used to track who made changes
    #example :
    #thing.save :updater_id => "4cef9936f61aa33717000001"

    #Also you can now pass :updater_id to update_attributes
    #example :
    #thing.update_attributes(:updater_id => "4cef9936f61aa33717000001", params[:thing])

    thing.versions_count 
    #=> 2

    thing.versions
    #=> [#<Version _id: BSON::ObjectId('4cef96c4f61aa33621000002'), data: {"_id"=>BSON::ObjectId('4cef96c4f61aa33621000001'), "version_message"=>nil, "version_number"=>nil, "name"=>"Dhruva Sagar", "date"=>2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 0, doc_id: "4cef96c4f61aa33621000001", message: nil, updater_id: nil>, #<Version _id: BSON::ObjectId('4cef96c4f61aa33621000003'), data: {"_id"=>BSON::ObjectId('4cef96c4f61aa33621000001'), "version_message"=>nil, "version_number"=>nil, "name"=>"Change Thing", "date"=>2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 1, doc_id: "4cef96c4f61aa33621000001", message: nil, updater_id: nil>]

    thing.all_versions
    #=> #<Plucky::Query doc_id: "4cef96c4f61aa33621000001", sort: [["pos", -1]]> 

    thing.rollback(:first)
    #=> #<Thing _id: BSON::ObjectId('4cef96c4f61aa33621000001'), version_message: nil, version_number: 0, name: "Dhruva Sagar", date: 2010-11-26 11:15:16 UTC>

    thing.rollback(:last)
    #=> #<Thing _id: BSON::ObjectId('4cef96c4f61aa33621000001'), version_message: nil, version_number: 0, name: "Dhruva Sagar", date: 2010-11-26 11:15:16 UTC>

    thing.rollback!(:latest)
    #=> #<Thing _id: BSON::ObjectId('4cef96c4f61aa33621000001'), version_message: nil, version_number: 1, name: "Change Thing", date: 2010-11-26 11:15:16 UTC>
    #rollback! saves the document as well

    thing.diff(:name, 0, 1)
    #=> "<del class=\"differ\">Change</del><ins class=\"differ\">Dhruva</ins> <del class=\"differ\">Thing</del><ins class=\"differ\">Sagar</ins>"

    thing.diff(:name, 0, 1, :ascii)
    #=> "{\"Change\" >> \"Dhruva\"} {\"Thing\" >> \"Sagar\"}"

    thing.diff(:name, 0, 1, :color)
    #=> "\e[31mChange\e[0m\e[32mDhruva\e[0m \e[31mThing\e[0m\e[32mSagar\e[0m"

    thing.current_version
    #=> #<Version _id: BSON::ObjectId('4cf03822f61aa30fd8000004'), data: {"_id"=>BSON::ObjectId('4cf03816f61aa30fd8000001'), "version_message"=>nil, "version_number"=>nil, "name"=>"Change Thing", "date"=>2010-11-26 22:43:34 UTC}, date: 2010-11-26 22:43:46 UTC, pos: nil, doc_id: "4cf03816f61aa30fd8000001", message: nil, updater_id: nil>

    thing.version_at(:first)
    #=> #<Version _id: BSON::ObjectId('4cef96c4f61aa33621000002'), data: {"_id"=>BSON::ObjectId('4cef96c4f61aa33621000001'), "version_message"=>nil, "version_number"=>nil, "name"=>"Dhruva Sagar", "date"=>2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 0, doc_id: "4cef96c4f61aa33621000001", message: nil, updater_id: nil>

    thing.version_at(:current)
    #=> #<Version _id: BSON::ObjectId('4cef986df61aa33621000004'), data: {"_id"=>BSON::ObjectId('4cef96c4f61aa33621000001'), "version_message"=>nil, "version_number"=>1, "name"=>"Change Thing", "date"=>2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:22:21 UTC, pos: nil, doc_id: "4cef96c4f61aa33621000001", message: nil, updater_id: nil>

    thing.version_at(:last)
    #=> #<Version _id: BSON::ObjectId('4cef96c4f61aa33621000002'), data: {"_id"=>BSON::ObjectId('4cef96c4f61aa33621000001'), "version_message"=>nil, "version_number"=>nil, "name"=>"Dhruva Sagar", "date"=>2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 0, doc_id: "4cef96c4f61aa33621000001", message: nil, updater_id: nil>

    thing.version_at(:latest)
    #=> #<Version _id: BSON::ObjectId('4cef96c4f61aa33621000003'), data: {"_id"=>BSON::ObjectId('4cef96c4f61aa33621000001'), "version_message"=>nil, "version_number"=>nil, "name"=>"Change Thing", "date"=>2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 1, doc_id: "4cef96c4f61aa33621000001", message: nil, updater_id: nil> 

    thing.version_at(10)
    #=> nil

    thing.delete_version(:all) # This will delete all versions and reset versions_count to 0
    # Or
    thing.delete_version(1) # This will delete the version at pos = 1, and reset the pos of all subsequent versions to one less to maintain linear sequence.

Problems or Questions?
----------------------
Hit up on the mongomapper google group:
http://groups.google.com/group/mongomapper

Hop on IRC:
irc://chat.freenode.net/#mongomapper

I am available on IRC with the name dhruvasagar, you could alternatively also contact me directly on dhruva.sagar@gmail.com

Copyright
---------
See LICENSE for details.
