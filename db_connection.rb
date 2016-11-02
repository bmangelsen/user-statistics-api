ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'test.sqlite3'
)
ActiveRecord::Migration.verbose = false
