require "sinatra"
require_relative "config/init"

get "/" do
  @tag = params["tag"].strip if params["tag"]

  if params["asin"]
    asin = params["asin"].strip
    if valid_asin?(asin)
      if asin_present?(asin)
        @warning = "ASIN(#{asin}) is already in a list."
      else
        add_asin(asin)
        @notice = "ASIN(#{asin}) was added. Feel free to add more.."
      end
    elsif(params["asin"].size > 10 && (a= find_asin(asin)))

      if asin_present?(a)
        @warning = "ASIN(#{a}) is already in a list."
      else
        add_asin(a)
        @notice = "ASIN(#{a}) was added. Feel free to add more.."
      end
    else
      @warning = "We didn't detect any ASIN or Amazon Product URL."
    end
  else
    return erb :landing if asins.empty?
  end

  erb :index
end

get "/integrate-browser" do
  erb :browser
end

get "/clear-list" do
  clean_asins
  redirect '/'
end

get "/:id" do
  lnk = Link.where(id: bijective_decode(params['id'])).first
  redirect lnk[:url]
end

post "/" do
  l = Link.insert(url: amazon_url(params))

  @short_url = shorten_link_id(l)
  clean_asins

  erb :done
end

helpers do
  def valid_asin?(asin)
    asin.match?(/\A[0-9,A-Z]{10}\z/)
  end

  def find_asin(url)
    if (m = url.match(/\/(?:dp|gp|asin)\/(?:product\/)?(\w{10})/))
     return m[1]
    else
      nil
    end
  end

  def shorten_link_id(link_id)
    "https://acart.to/#{bijective_encode(link_id)}"
  end

  def asin_present?(asin)
    asins.include?(asin)
  end

  def clean_asins
    cookies.delete_if {|c| asin_keys.include? c}
  end

  OUR_TAG = "harempacom-20".freeze

  def amazon_url(params)
    Carriage.build(
      params["items"].values,
      locale: params["locale"],
      tag: params["associate_tag"] || OUR_TAG
    )
  end

  def asin_keys
    cookies.keys.select {|v| v.start_with?('asin_')}
  end

  def asins
    asin_keys.map{|v| v[5..v.size]}
  end

  def add_asin(asin)
    cookies["asin_#{asin}"] = '1'
  end

  # Simple bijective function
  #   Basically encodes any integer into a base(n) string,
  #     where n is ALPHABET.length.
  #   Based on pseudocode from http://stackoverflow.com/questions/742013/how-to-code-a-url-shortener/742047#742047

  ALPHABET =
    "mzUfkcIW8A6GqrnwZT0Hi5uDgS9tLNpOQBXKs7jydV1R2aoJEP4vCYbeFx3Mhl".split(//)
  # make your own alphabet using:
  # (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle.join

  def bijective_encode(i)
    return ALPHABET[0] if i == 0
    s = ''
    base = ALPHABET.length
    while i > 0
      s << ALPHABET[i.modulo(base)]
      i /= base
    end
    s.reverse
  end

  def bijective_decode(s)
    i = 0
    base = ALPHABET.length
    s.each_char { |c| i = i * base + ALPHABET.index(c) }
    i
  end
end
