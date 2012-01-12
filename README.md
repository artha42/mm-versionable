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

        # Store a maximum of 20 versions of a thing. Default is to store an unlimited number of versions.
        versioned :max => 20

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
    #=&gt; [#&lt;Version _id: BSON::ObjectId('4cef96c4f61aa33621000002'), data: {&quot;_id&quot;=&gt;BSON::ObjectId('4cef96c4f61aa33621000001'), &quot;version_message&quot;=&gt;nil, &quot;version_number&quot;=&gt;nil, &quot;name&quot;=&gt;&quot;Dhruva Sagar&quot;, &quot;date&quot;=&gt;2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 0, doc_id: &quot;4cef96c4f61aa33621000001&quot;, message: nil, updater_id: nil&gt;, #&lt;Version _id: BSON::ObjectId('4cef96c4f61aa33621000003'), data: {&quot;_id&quot;=&gt;BSON::ObjectId('4cef96c4f61aa33621000001'), &quot;version_message&quot;=&gt;nil, &quot;version_number&quot;=&gt;nil, &quot;name&quot;=&gt;&quot;Change Thing&quot;, &quot;date&quot;=&gt;2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 1, doc_id: &quot;4cef96c4f61aa33621000001&quot;, message: nil, updater_id: nil&gt;]

    thing.all_versions
    #=&gt; #&lt;Plucky::Query doc_id: &quot;4cef96c4f61aa33621000001&quot;, sort: [[&quot;pos&quot;, -1]]&gt; 

    thing.rollback(:first)
    #=&gt; #&lt;Thing _id: BSON::ObjectId('4cef96c4f61aa33621000001'), version_message: nil, version_number: 0, name: &quot;Dhruva Sagar&quot;, date: 2010-11-26 11:15:16 UTC&gt;

    thing.rollback(:last)
    #=&gt; #&lt;Thing _id: BSON::ObjectId('4cef96c4f61aa33621000001'), version_message: nil, version_number: 0, name: &quot;Dhruva Sagar&quot;, date: 2010-11-26 11:15:16 UTC&gt;

    thing.rollback!(:latest)
    #=&gt; #&lt;Thing _id: BSON::ObjectId('4cef96c4f61aa33621000001'), version_message: nil, version_number: 1, name: &quot;Change Thing&quot;, date: 2010-11-26 11:15:16 UTC&gt;
    #rollback! saves the document as well

    thing.diff(:name, 0, 1)
    #=&gt; &quot;&lt;del class=\&quot;differ\&quot;&gt;Change&lt;/del&gt;&lt;ins class=\&quot;differ\&quot;&gt;Dhruva&lt;/ins&gt; &lt;del class=\&quot;differ\&quot;&gt;Thing&lt;/del&gt;&lt;ins class=\&quot;differ\&quot;&gt;Sagar&lt;/ins&gt;&quot;

    thing.diff(:name, 0, 1, :ascii)
    #=&gt; &quot;{\&quot;Change\&quot; &gt;&gt; \&quot;Dhruva\&quot;} {\&quot;Thing\&quot; &gt;&gt; \&quot;Sagar\&quot;}&quot;

    thing.diff(:name, 0, 1, :color)
    #=&gt; &quot;\e[31mChange\e[0m\e[32mDhruva\e[0m \e[31mThing\e[0m\e[32mSagar\e[0m&quot;

    thing.current_version
    #=&gt; #&lt;Version _id: BSON::ObjectId('4cf03822f61aa30fd8000004'), data: {&quot;_id&quot;=&gt;BSON::ObjectId('4cf03816f61aa30fd8000001'), &quot;version_message&quot;=&gt;nil, &quot;version_number&quot;=&gt;nil, &quot;name&quot;=&gt;&quot;Change Thing&quot;, &quot;date&quot;=&gt;2010-11-26 22:43:34 UTC}, date: 2010-11-26 22:43:46 UTC, pos: nil, doc_id: &quot;4cf03816f61aa30fd8000001&quot;, message: nil, updater_id: nil&gt;

    thing.version_at(:first)
    #=&gt; #&lt;Version _id: BSON::ObjectId('4cef96c4f61aa33621000002'), data: {&quot;_id&quot;=&gt;BSON::ObjectId('4cef96c4f61aa33621000001'), &quot;version_message&quot;=&gt;nil, &quot;version_number&quot;=&gt;nil, &quot;name&quot;=&gt;&quot;Dhruva Sagar&quot;, &quot;date&quot;=&gt;2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 0, doc_id: &quot;4cef96c4f61aa33621000001&quot;, message: nil, updater_id: nil&gt;

    thing.version_at(:current)
    #=&gt; #&lt;Version _id: BSON::ObjectId('4cef986df61aa33621000004'), data: {&quot;_id&quot;=&gt;BSON::ObjectId('4cef96c4f61aa33621000001'), &quot;version_message&quot;=&gt;nil, &quot;version_number&quot;=&gt;1, &quot;name&quot;=&gt;&quot;Change Thing&quot;, &quot;date&quot;=&gt;2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:22:21 UTC, pos: nil, doc_id: &quot;4cef96c4f61aa33621000001&quot;, message: nil, updater_id: nil&gt;

    thing.version_at(:last)
    #=&gt; #&lt;Version _id: BSON::ObjectId('4cef96c4f61aa33621000002'), data: {&quot;_id&quot;=&gt;BSON::ObjectId('4cef96c4f61aa33621000001'), &quot;version_message&quot;=&gt;nil, &quot;version_number&quot;=&gt;nil, &quot;name&quot;=&gt;&quot;Dhruva Sagar&quot;, &quot;date&quot;=&gt;2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 0, doc_id: &quot;4cef96c4f61aa33621000001&quot;, message: nil, updater_id: nil&gt;

    thing.version_at(:latest)
    #=&gt; #&lt;Version _id: BSON::ObjectId('4cef96c4f61aa33621000003'), data: {&quot;_id&quot;=&gt;BSON::ObjectId('4cef96c4f61aa33621000001'), &quot;version_message&quot;=&gt;nil, &quot;version_number&quot;=&gt;nil, &quot;name&quot;=&gt;&quot;Change Thing&quot;, &quot;date&quot;=&gt;2010-11-26 11:15:16 UTC}, date: 2010-11-26 11:15:16 UTC, pos: 1, doc_id: &quot;4cef96c4f61aa33621000001&quot;, message: nil, updater_id: nil&gt; 

    thing.version_at(10)
    #=> nil

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
