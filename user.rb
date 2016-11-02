require 'active_record'

class User < ActiveRecord::Base
  validates :username, :last_logged_on, :joined_on, :total_site_visits, presence: true
end
