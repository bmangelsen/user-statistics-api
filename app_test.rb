require "bundler/setup"
require "minitest/autorun"
require "minitest/pride"
require "rack/test"
require "pry"
require "./app"

begin CompanyDataMigration.migrate(:down);
rescue; end
CompanyDataMigration.migrate(:up)

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

end
