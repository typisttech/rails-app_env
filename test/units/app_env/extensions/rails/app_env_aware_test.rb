require "minitest/mock"
require_relative "../../../../test_helper"

module Rails::AppEnv::Extensions
  class AppEnvAwareTest < ActiveSupport::TestCase
    def setup
      AppEnvAware.instance_variable_set :@_app_env, nil
    end

    test ".app_env reads from APP_ENV" do
      switch_env("APP_ENV", "foo") do
        Rails.stub(:env, "bar") do
          actual = AppEnvAware.app_env

          assert_equal "foo", actual
          assert_predicate actual, :foo?

          refute_predicate actual, :bar?
          refute_predicate actual, :test?
        end
      end
    end

    test ".app_env falls back to read from Rails.env" do
      switch_env("APP_ENV", nil) do
        Rails.stub(:env, "bar") do
          actual = AppEnvAware.app_env

          assert_equal "bar", actual
          assert_predicate actual, :bar?

          refute_predicate actual, :foo?
          refute_predicate actual, :test?
        end
      end
    end

    private

    def switch_env(key, value)
      old, ENV[key] = ENV[key], value
      yield
    ensure
      ENV[key] = old
    end
  end
end
