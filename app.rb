require 'sinatra'
require "sinatra/reloader" if development?
require 'pry' if development?
require 'rack/ssl-enforcer'

configure do
  use Rack::SslEnforcer if ENV['FORCE_SSL']
end

get '/' do
	erb :index
end

post '/' do
	puts params
end

