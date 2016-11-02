require 'minitest/autorun'
require 'minitest/pride'
require './user'
require './migration'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'test.sqlite3'
)
ActiveRecord::Migration.verbose = false

class UserTest < Minitest::Test

  def setup
    begin UserMigration.migrate(:down); rescue; end
    UserMigration.migrate(:up)
  end

  def test_can_create_user
    ben = User.create!(username: "Ben", last_logged_on: Date.new(2016/10/31), joined_on: Date.new(2016/01/25), total_site_visits: 17)
    assert ben
    assert_equal "Ben", ben.username
    refute_equal nil, ben.id
  end

  def test_user_must_have_username
    assert_raises do
      User.create!(last_logged_on: Date.new(2016/10/31), joined_on: Date.new(2016/01/25), total_site_visits: 17)
    end
  end

  def test_user_must_have_last_logged_on
    assert_raises do
      User.create!(username: "Ben", joined_on: Date.new(2016/01/25), total_site_visits: 17)
    end
  end

  def test_user_must_have_joined_on
    assert_raises do
      User.create!(username: "Ben", last_logged_on: Date.new(2016/10/31), total_site_visits: 17)
    end
  end

  def test_user_must_have_total_site_visits
    assert_raises do
      User.create!(username: "Ben", last_logged_on: Date.new(2016/10/31), joined_on: Date.new(2016/01/25))
    end
  end

end
