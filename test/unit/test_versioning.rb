require 'test_helper'

class VersioningTest < Test::Unit::TestCase
  context 'Versioning enabled' do
    setup do
      @user = User.first
    end
    should 'respond to method version_message' do
      assert @user.respond_to?(:version_message)
    end
    should 'respond to method version_message=' do
      assert @user.respond_to?(:version_message=)
    end
    should 'respond to method version_number' do
      assert @user.respond_to?(:version_number)
    end
    should 'respond to method versions' do
      assert @user.respond_to?(:versions)
    end
    should 'respond to method all_versions' do
      assert @user.respond_to?(:all_versions)
    end
    should 'respond to method rollback' do
      assert @user.respond_to?(:rollback)
    end
    should 'respond to method rollback!' do
      assert @user.respond_to?(:rollback!)
    end
    should 'respond to method diff' do
      assert @user.respond_to?(:diff)
    end
    should 'respond to method current_version' do
      assert @user.respond_to?(:current_version)
    end
    should 'respond to method version_at' do
      assert @user.respond_to?(:version_at)
    end
    should 'respond to method save_version' do
      assert @user.respond_to?(:save_version)
    end
  end

  context 'Version manipulations' do
    setup do
      @user = User.first
    end
    should 'return the total versions_count' do
      assert @user.versions_count
    end
    should 'return last 10 or lesser versions' do
      assert @user.versions
      assert @user.versions.count <= 10
    end
    should 'return the plucky query for all versions' do
      assert @user.all_versions
      assert @user.all_versions.is_a?(Plucky::Query)
    end
    should 'load first version on rollback :first' do
      assert_equal @user.rollback(:first).fname, 'dhruva'
      assert_equal @user.version_number, 0
    end
    should 'load last version on rollback :last' do
      assert_equal @user.rollback(:last).fname, 'Dhruva'
      assert @user.posts.empty?
      assert_equal @user.version_number, (@user.versions_count - 2)
    end
    should 'load latest version on rollback :latest' do
      assert_equal @user.rollback(:latest).fname, 'Dhruva'
      assert !@user.posts.empty?
      assert_equal @user.version_number, (@user.versions_count - 1)
    end
    should 'revert to first version on rollback!' do
      @user.rollback!(:first)
      assert_equal @user.fname, 'dhruva'
      assert_equal @user.version_number, 0
    end
    should 'revert to last version on rollback!' do
      @user.rollback!(:last)
      assert_equal @user.fname, 'Dhruva'
      assert @user.posts.empty?
      assert_equal @user.version_number, (@user.versions_count - 2)
    end
    should 'revert to last version on rollback! without args' do
      @user.rollback!
      assert_equal @user.fname, 'Dhruva'
      assert @user.posts.empty?
      assert_equal @user.version_number, (@user.versions_count - 2)
    end
    should 'only create a new version when the data changes' do
      versions_count = @user.versions_count
      @user.save
      assert_equal versions_count, @user.versions_count
    end
    should 'revert to latest version on rollback!' do
      @user.rollback!(:latest)
      assert @user.fname == 'Dhruva'
      assert !@user.posts.empty?
      assert_equal @user.version_number, (@user.versions_count - 1)
    end
    should 'create a new version without saving' do
      user = User.create :fname => 'Dave', :lname => 'Smiggins'
      initial_version_number = user.version_number
      user.fname = 'Steve'
      user.save_version
      assert_equal user.version_number, user.versions.last.pos
      user.reload
      assert_equal initial_version_number, user.version_number
    end
    should "allow protected attributes to be changed" do
      user = User.create :fname => 'Dave', :lname => 'Smiggins'
      user.address = "123 Main St"
      user.save
      user.rollback!(:first)
      assert_equal nil, user.address
    end
  end

  context 'Versioning with update_attributes' do
    setup do
      @user = User.first
    end
    should 'create a new version for changes' do
      versions_count = @user.versions_count
      @user.update_attributes(:fname => 'Dave')
      @user.reload
      assert_equal @user.fname, 'Dave'
      assert_equal @user.versions_count, (versions_count + 1)
    end
    should 'not create a new version without changes' do
      versions_count = @user.versions_count
      @user.update_attributes
      assert_equal @user.versions_count, versions_count
    end
  end

  context 'assigning updater_id' do
    setup do
      @user = User.first
    end
    should 'create a new version and update the updater_id for save' do
      versions_count = @user.versions_count
      @user.fname = 'Updater1'
      @user.save(:updater_id => 'test_id')
      assert_equal @user.versions_count, (versions_count + 1)
      assert_equal @user.version_at(:latest).updater_id, 'test_id'
    end
    should 'create a new version and update the updater_id for update_attributes' do
      versions_count = @user.versions_count
      @user.update_attributes(:updater_id => 'test_id_2', :fname => 'Updater2')
      assert_equal @user.versions_count, (versions_count + 1)
      assert_equal @user.version_at(:latest).updater_id, 'test_id_2'
    end
  end
end
