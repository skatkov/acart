require "sinatra"
require_relative "config/init"

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
  redirect Link.where(id: bijective_decode(params['id'])).first[:url]
end

post "/" do
  l = Link.insert(url: amazon_url(params))
  @amazon_url = "https://www.acart.to/#{bijective_encode(l)}"

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

  # Simple bijective function
  #   Basically encodes any integer into a base(n) string,
  #     where n is ALPHABET.length.
  #   Based on pseudocode from http://stackoverflow.com/questions/742013/how-to-code-a-url-shortener/742047#742047

  ALPHABET =
    "mzUfkcIW8A6GqrnwZT0Hi5uDgS9tLNpOQBXKs7jydV1R2aoJEP4vCYbeFx3Mhl".split(//)
  # make your own alphabet using:
  # (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle.join

  def bijective_encode(i)
    # from http://refactormycode.com/codes/125-base-62-encoding
    # with only minor modification
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
    # based on base2dec() in Tcl translation
    # at http://rosettacode.org/wiki/Non-decimal_radices/Convert#Ruby
    i = 0
    base = ALPHABET.length
    s.each_char { |c| i = i * base + ALPHABET.index(c) }
    i
  end
end
