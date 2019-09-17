# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests, alphabetically.
    fixtures :all
    include ApplicationHelper

    def logged_in?
      !session[:user_id].nil?
    end
  end
end
