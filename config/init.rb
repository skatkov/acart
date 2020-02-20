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

DB = Sequel.connect(
  ENV['DATABASE_URL'] || "postgres:///acart_#{ENV.fetch('RACK_ENV', 'development')}?user=acart"
)


Link = DB[:links]
