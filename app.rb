require 'sinatra'
require "sinatra/reloader" if development?
require 'pry' if development?
require 'rack/ssl-enforcer'

configure do
  use Rack::SslEnforcer if ENV['FORCE_SSL']
  set :session_secret, 'asdfa2342923422f1adc05c837fa234230e3594b93824b00e930ab0fb94b'
  # don't use `enable :sessions`, use:
  use Rack::Session::Cookie, :key => '_rack_session',
      :path => '/',
      :expire_after => 2592000, # In seconds
      :secret => settings.session_secret
end

get '/' do
  if params['asin']
    if valid_asin?(params['asin'])
      @notice = "ASIN(#{params[:asin]}) was added. Feel free to add more.."
    else
      @warning = "ASIN should be 10 characters long, letters or numbers"
    end
  end

  erb :index
end

post '/' do
  if true
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
