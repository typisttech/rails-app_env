require "minitest/mock"
require_relative "../../../../test_helper"

module Rails::AppEnv::Extensions
  class AppConfigurableTest < ActiveSupport::TestCase
    test ".app_config_for delegates to Rails.application.config_for" do
      app_env = "foo"
      expected = Object.new

      mock = Minitest::Mock.new
      mock.expect(:call, expected, [:bar], env: app_env)

      Rails.stub(:app_env, app_env) do
        Rails.application.stub(:config_for, mock) do
          assert_same expected, AppConfigurable.app_config_for(:bar)
        end
      end

      mock.verify
    end
  end
end
