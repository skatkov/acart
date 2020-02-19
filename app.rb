require 'sinatra'
require "sinatra/reloader" if development?
require 'pry' if development?

get '/' do
	erb :index
end

post '/' do
	puts params
end

