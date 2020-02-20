require "sinatra"
require "sinatra/reloader" if development?
require "pry" if development?
require "rack/ssl-enforcer"
require "carriage"
require_relative "config/init"

configure do
  use Rack::SslEnforcer if ENV["FORCE_SSL"]
end

get "/" do
  if params["asin"]
    if valid_asin?(params["asin"])
      @notice = "ASIN(#{params[:asin]}) was added. Feel free to add more.."
    else
      @warning = "ASIN should be 10 characters long, letters or numbers"
    end
  end

  erb :index
end

get "/:id" do
  redirect Link.where(id: params['id']).first[:url]
end

post "/" do
  l = Link.insert(url: amazon_url(params))
  @amazon_url = "https://www.acart.to/#{l}"

  erb :index
end

helpers do
  def valid_asin?(asin)
    asin.match?(/\A[0-9,A-Z]{10}\z/)
  end

  def amazon_url(params)
    Carriage.build(
      params["items"].values,
      locale: params["locale"],
      tag: params["associate_tag"]
    )
  end
end
