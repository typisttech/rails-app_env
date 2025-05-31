require_relative "../test_helper"
require_relative "runner_helper"

module Rails::AppEnv::FeaturesTest
  class InfoTest < ActiveSupport::TestCase
    include RunnerHelper

    TEST_CASES = {
      "is APP_ENV when both APP_ENV and RAILS_ENV are present": {
        expected: "foo",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "bar"
        }
      },
      "is APP_ENV when APP_ENV is present but RAILS_ENV is blank": {
        expected: "foo",
        env: {
          "APP_ENV" => "foo"
        }
      },
      "falls back to RAILS_ENV when APP_ENV is blank but RAILS_ENV is present": {
        expected: "foo",
        env: {
          "RAILS_ENV" => "foo"
        }
      },
      "falls back to DEFAULT_RAILS_ENV when both APP_ENV and RAILS_ENV are blank": {
        expected: DEFAULT_RAILS_ENV # development
      }
    }

    TEST_CASES.each_key do |name|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
        test "Rails::Info's 'Application environment' #{name}" do
          assert_rails_info_property(**TEST_CASES[:"#{name}"])
        end
      RUBY
    end

    private

    def assert_rails_info_property(expected:, **options)
      assert_runner_puts expected, 'Rails::Info.properties.value_for("Application environment")', **options
    end
  end
end
