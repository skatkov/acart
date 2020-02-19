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
  form = BundleForm.new(params)
  if form.save
    redirect '/done'
  else
    erb :index
  end
end

get '/done' do
  erb :done
end

class BundleForm
  def initialize(*params)

  end

  def save
    true
  end
end
