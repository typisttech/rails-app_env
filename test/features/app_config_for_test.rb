require "minitest/mock"
require_relative "../test_helper"
require_relative "env_helpers"

module Rails::AppEnv::FeaturesTest
  class AppConfigForTest < ActiveSupport::TestCase
    include EnvHelpers

    test "Rails.application.app_config_for delegates to Rails.application.config_for" do
      app_env = "foo"
      expected = Object.new

      mock = Minitest::Mock.new
      mock.expect(:call, expected, [:bar], env: app_env)

      with_app_env(app_env) do
        Rails.application.stub(:config_for, mock) do
          assert_same expected, Rails.application.app_config_for(:bar)
        end
      end

      mock.verify
    end
  end
end
