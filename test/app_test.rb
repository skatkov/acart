require_relative 'test_helper'

class MyTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get '/'
    assert last_response.ok?
  end

  def test_shortener
    post '/', {"items"=>
                 {"0"=>{"asin"=>"B07K8CZ5WT", "quantity"=>"1"},
                  "1"=>{"asin"=>"B07QYXD2TH", "quantity"=>"1"}},
               "associate_tag"=>"",
               "locale"=>"US"}

    assert last_response.redirect?
  end
end
