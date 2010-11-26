require 'test_helper'

class VersioningTest < Test::Unit::TestCase
  context 'Versioning enabled' do
    setup do
      @user = User.first
    end
    should 'respond to method version_message' do
      assert @user.respond_to?(:version_message)
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
      assert @user.rollback(:first).fname == 'dhruva'
      assert @user.version_number == 0
    end
    should 'load last version on rollback :last' do
      assert @user.rollback(:last).fname == 'Dhruva'
      assert @user.posts.empty?
      assert @user.version_number == (@user.versions_count - 2)
    end
    should 'load latest version on rollback :latest' do
      assert @user.rollback(:latest).fname == 'Dhruva'
      assert !@user.posts.empty?
      assert @user.version_number == (@user.versions_count - 1)
    end
    should 'revert to first version on rollback!' do
      @user.rollback!(:first)
      assert @user.fname == 'dhruva'
      assert @user.version_number == 0
    end
    should 'revert to last version on rollback!' do
      @user.rollback!(:last)
      assert @user.fname == 'Dhruva'
      assert @user.posts.empty?
      assert @user.version_number == (@user.versions_count - 2)
    end
    should 'revert to latest version on rollback!' do
      @user.rollback!(:latest)
      assert @user.fname == 'Dhruva'
      assert !@user.posts.empty?
      assert @user.version_number == (@user.versions_count - 1)
    end
  end
end
