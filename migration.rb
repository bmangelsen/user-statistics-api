require 'active_record'

class UserMigration < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.date :last_logged_on
      t.date :joined_on
      t.integer :total_site_visits
    end
  end
end
