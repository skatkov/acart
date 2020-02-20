require "sqlite3"
require "sequel"
require "sinatra/reloader" if development?
require "pry" if development?
require "rack/ssl-enforcer"
require "carriage"

begin
  require_relative '.env.rb'
rescue LoadError
end

configure do
  use Rack::SslEnforcer if ENV["FORCE_SSL"]
end

# Delete APP_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  APP_DATABASE_URL may contain passwords.
DB = Sequel.connect("postgres:///acart_development?user=acart")

DB.create_table :links do
  primary_key :id
  String :url
end

Link = DB[:links]
