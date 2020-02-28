# test_helper.rb
ENV["RACK_ENV"] = "test"
require "minitest/autorun"

require_relative "../app"
