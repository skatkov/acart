require_relative "test_helper"

class MyTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get "/"
    assert last_response.ok?
  end

  def test_redirect
    id = Link.insert(url: 'https://amazon.com/dp/test')
    get "/#{bijective_encode(id)}"
    assert last_response.redirect?
    assert_equal 'https://amazon.com/dp/test', last_response.location
  end

  def test_add_asin
    asin = 'B07K8CZ5WT'
    get "/?asin=#{asin}"

    assert last_response.body.include?("ASIN(#{asin}) was added. Feel free to add more..")
  end
  def test_add_wrong_asin
    wrong_asin = 'B07K8CZ5'
    get "/?asin=#{wrong_asin}"

    refute last_response.body.include?("ASIN(#{wrong_asin}) was added. Feel free to add more..")
    assert last_response.body.include?("ASIN should be 10 characters long, letters or numbers.")
  end


  def test_shortener
    cnt = Link.count
    post "/", {"items" =>
                 {"0" => {"asin" => "B07K8CZ5WT", "quantity" => "1"},
                  "1" => {"asin" => "B07QYXD2TH", "quantity" => "1"},},
               "associate_tag" => "",
               "locale" => "US",}

    refute last_response.redirect?
    assert last_response.ok?
    assert_equal(cnt+1, Link.count)
    assert Link.to_a.last[:url].end_with?('?ASIN.1=B07K8CZ5WT&Quantity.1=1&ASIN.2=B07QYXD2TH&Quantity.2=1')
  end

  def test_shortener_multiple
    cnt = Link.count
    post "/", {"items" =>
                 {"0" => {"asin" => "B07K8CZ5WT", "quantity" => "1"},
                  "1" => {"asin" => "B07QYXD2TH", "quantity" => "2"},},
               "associate_tag" => "",
               "locale" => "US",}

    refute last_response.redirect?
    assert last_response.ok?
    assert_equal(cnt+1, Link.count)
    assert Link.to_a.last[:url].end_with?('?ASIN.1=B07K8CZ5WT&Quantity.1=1&ASIN.2=B07QYXD2TH&Quantity.2=2')
  end

  private
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
end
