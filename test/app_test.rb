require_relative 'test_helper'

class MyTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get '/'
    assert last_response.ok?
  end

  def test_shortener
    post '/', asins: {"0" => { id: 'B07K8CZ5WT', quantity: "1"}}, region: 'US'

    assert last_response.redirect?
  end

  def test_done
    get '/done'
    assert last_response.ok?
    assert last_response.body.include?("Product bundle was successfully submitted.")
  end
end
