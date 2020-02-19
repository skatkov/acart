require 'sinatra'
require "sinatra/reloader" if development?
require 'pry' if development?
require 'rack/ssl-enforcer'

configure do
  use Rack::SslEnforcer if ENV['FORCE_SSL']
end

get '/' do
  if params['asin']
    if valid_asin?(params['asin'])
      @notice = "ASIN(#{params[:asin]}) was added. Feel free to add more.."
    else
      @warning = "ASIN(#{params[:asin]}) should be 10 characters long, letters or numbers"
    end
  end

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

helpers do
  def valid_asin?(asin)
    asin.match?(/\A[0-9,A-Z]{10}\z/)
  end
end

class BundleForm
  def initialize(*params)

  end

  def save
    true
  end
end
