require 'sinatra'
require "sinatra/reloader" if development?
require 'haml'

get '/' do
  haml :index
end

