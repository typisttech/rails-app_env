require_relative "../test_helper"
require_relative "runner_helper"

module Rails::AppEnv::FeaturesTest
  class InfoTest < ActiveSupport::TestCase
    include RunnerHelper

    TEST_CASES = [
      {
        name: "is APP_ENV when both APP_ENV and RAILS_ENV are present",
        expected: "foo",
        app_env: "foo",
        rails_env: "bar",
        secret_key_base_dummy: "1"
      },
      {
        name: "is APP_ENV when APP_ENV is present but RAILS_ENV is blank",
        expected: "foo",
        app_env: "foo"
      },
      {
        name: "falls back to RAILS_ENV when APP_ENV is blank but RAILS_ENV is present",
        expected: "foo",
        rails_env: "foo",
        secret_key_base_dummy: "1"
      },
      {
        name: "falls back to DEFAULT_RAILS_ENV when both APP_ENV and RAILS_ENV are blank",
        expected: DEFAULT_RAILS_ENV # development
      }
    ]

    TEST_CASES.each_with_index do |args, i|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
        test "Rails::Info's 'Application environment' #{args[:name]}" do
          assert_runner args[:expected], 'Rails::Info.properties.value_for("Application environment")', **args
        end
      RUBY
    end
  end
end
