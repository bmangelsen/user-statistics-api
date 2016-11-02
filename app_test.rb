require "bundler/setup"
require "minitest/autorun"
require "minitest/pride"
require "rack/test"
require "pry"
require "./app"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def setup
    begin UserMigration.migrate(:down);
    rescue; end
    UserMigration.migrate(:up)
    User.create!(username: "Ben", last_logged_on: Date.new(2016/10/31), joined_on: Date.new(2016/01/25), total_site_visits: 17)
    User.create!(username: "Farimah", last_logged_on: Date.new(2016/10/28), joined_on: Date.new(2016/02/17), total_site_visits: 7)
    User.create!(username: "Allie", last_logged_on: Date.new(2016/10/05), joined_on: Date.new(2016/05/16), total_site_visits: 34)
    User.create!(username: "Alex", last_logged_on: Date.new(2016/10/15), joined_on: Date.new(2016/03/8), total_site_visits: 20)
    User.create!(username: "Russell", last_logged_on: Date.new(2016/9/18), joined_on: Date.new(2016/7/04), total_site_visits: 103)
  end

  def test_can_create_user
    header "content_type", "application/json"
    payload = {username: "Bob", last_logged_on: Date.new(2016/10/15), joined_on: Date.new(2016/05/20), total_site_visits: 57}
    post "/users", payload.to_json
    assert_equal 201, last_response.status
    assert_equal User.last.id, JSON.parse(last_response.body)["id"]
  end

  def test_422_response_and_error_message_when_user_fails_to_save
    header "content_type", "application/json"
    payload = {last_logged_on: Date.new(2016/10/15), joined_on: Date.new(2016/05/20), total_site_visits: 57}
    post "/users", payload.to_json
    assert_equal 422, last_response.status
    assert_equal "Username can't be blank", JSON.parse(last_response.body)['errors']['full_messages'][0]
  end

  def test_can_delete_user
    delete "/users/#{User.last.id}"
    assert_equal 4, User.all.count
    refute User.find_by(id: 5)
  end

  def test_404_for_user_not_in_database
    delete "/users/#{User.last.id + 1}"
    assert_equal 404, last_response.status
    assert_equal "User with id ##{User.last.id + 1} does not exist", JSON.parse(last_response.body)["message"]
  end

  def test_get_total_site_visits
    get "/visits"
    assert last_response.ok?
    assert_equal 181, last_response.body.to_i
  end

end
