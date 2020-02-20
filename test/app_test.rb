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
    get "/#{id}"
    assert last_response.redirect?
    assert_equal 'https://amazon.com/dp/test', last_response.location
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
  end
end
