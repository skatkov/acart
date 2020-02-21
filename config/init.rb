require 'sinatra/contrib'
require "sinatra/reloader" if development?
require "pry" if development?
require "rack/ssl-enforcer"
require "carriage"
require_relative '../db'


begin
  require_relative '.env.rb'
rescue LoadError
end

configure do
  use Rack::SslEnforcer if ENV["FORCE_SSL"]
end
