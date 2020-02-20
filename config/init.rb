require "sqlite3"
require "sequel"
require "sinatra/reloader" if development?
require "pry" if development?
require "rack/ssl-enforcer"
require "carriage"

configure do
  use Rack::SslEnforcer if ENV["FORCE_SSL"]
end

DB = Sequel.sqlite # memory database, requires sqlite3

DB.create_table :links do
  primary_key :id
  String :url
end

Link = DB[:links]
