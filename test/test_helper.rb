# test_helper.rb
ENV["RACK_ENV"] = "test"
require "minitest/autorun"
require "pry"

require_relative "../app"
