require 'sqlite3'
require 'sequel'

DB = Sequel.sqlite # memory database, requires sqlite3

DB.create_table :links do
  primary_key :id
  String :url
end

Link = DB[:links]
