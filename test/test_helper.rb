# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
unless ENV['NOCOV']
  require 'simplecov'
  SimpleCov.start 'rails'
end
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

    # Log in as a prticular user
    def log_in_as(user)
      session[:user_id] = user.id
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Log in as a particular user
    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, params: { session: { email: user.email,
                                            password: password,
                                            remember_me: remember_me } }
    end
  end
end
