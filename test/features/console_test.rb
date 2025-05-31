require_relative "../test_helper"
require_relative "console_helpers"

module Rails::AppEnv::FeaturesTest
  class ConsoleTest < ActiveSupport::TestCase
    include ConsoleHelpers

    TEST_CASES = {
      "includes Rails.app_env when APP_ENV is custom and RAILS_ENV is custom": {
        expected: "bar:foo",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "bar"
        }
      },
      "includes Rails.app_env when APP_ENV is custom and RAILS_ENV is production": {
        expected: "prod:foo",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "production"
        }
      },
      "includes Rails.app_env when APP_ENV is custom and RAILS_ENV is development": {
        expected: "dev:foo",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "development"
        }
      },
      "includes Rails.app_env when APP_ENV is custom and RAILS_ENV is test": {
        expected: "test:foo",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "test"
        }
      },

      "includes Rails.app_env when APP_ENV is production and RAILS_ENV is custom": {
        expected: "bar:prod",
        env: {
          "APP_ENV" => "production",
          "RAILS_ENV" => "bar"
        }
      },
      "includes Rails.app_env when APP_ENV is production and RAILS_ENV is development": {
        expected: "dev:prod",
        env: {
          "APP_ENV" => "production",
          "RAILS_ENV" => "development"
        }
      },
      "includes Rails.app_env when APP_ENV is production and RAILS_ENV is test": {
        expected: "test:prod",
        env: {
          "APP_ENV" => "production",
          "RAILS_ENV" => "test"
        }
      },

      "includes Rails.app_env when APP_ENV is development and RAILS_ENV is custom": {
        expected: "bar:dev",
        env: {
          "APP_ENV" => "development",
          "RAILS_ENV" => "bar"
        }
      },
      "includes Rails.app_env when APP_ENV is development and RAILS_ENV is production": {
        expected: "prod:dev",
        env: {
          "APP_ENV" => "development",
          "RAILS_ENV" => "production"
        }
      },
      "includes Rails.app_env when APP_ENV is development and RAILS_ENV is test": {
        expected: "test:dev",
        env: {
          "APP_ENV" => "development",
          "RAILS_ENV" => "test"
        }
      },

      "does not include Rails.app_env when both APP_ENV and RAILS_ENV are custom": {
        expected: "foo",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "foo"
        }
      },
      "does not include Rails.app_env when both APP_ENV and RAILS_ENV are production": {
        expected: "prod",
        env: {
          "APP_ENV" => "production",
          "RAILS_ENV" => "production"
        }
      },
      "does not include Rails.app_env when both APP_ENV and RAILS_ENV are development": {
        expected: "dev",
        env: {
          "APP_ENV" => "development",
          "RAILS_ENV" => "development"
        }
      },
      "does not include Rails.app_env when both APP_ENV and RAILS_ENV are test": {
        expected: "test",
        env: {
          "APP_ENV" => "test",
          "RAILS_ENV" => "test"
        }
      },

      "does not include Rails.app_env when APP_ENV is blank and RAILS_ENV is custom": {
        expected: "foo",
        env: {
          "RAILS_ENV" => "foo"
        }
      },
      "does not include Rails.app_env when APP_ENV is blank and RAILS_ENV is production": {
        expected: "prod",
        env: {
          "RAILS_ENV" => "production"
        }
      },
      "does not include Rails.app_env when APP_ENV is blank and RAILS_ENV is development": {
        expected: "dev",
        env: {
          "RAILS_ENV" => "development"
        }
      },
      "does not include Rails.app_env when APP_ENV is blank and RAILS_ENV is test": {
        expected: "test",
        env: {
          "RAILS_ENV" => "test"
        }
      },

      "includes Rails.app_env when APP_ENV is custom and RAILS_ENV is blank": {
        expected: "dev:foo",
        env: {
          "APP_ENV" => "foo"
        }
      },
      "includes Rails.app_env when APP_ENV is production and RAILS_ENV is blank": {
        expected: "dev:prod",
        env: {
          "APP_ENV" => "production"
        }
      },
      "includes Rails.app_env when APP_ENV is test and RAILS_ENV is blank": {
        expected: "dev:test",
        env: {
          "APP_ENV" => "test"
        }
      },
      "does not include Rails.app_env when APP_ENV is development and RAILS_ENV is blank": {
        expected: "dev",
        env: {
          "APP_ENV" => "development"
        }
      },

      "does not include Rails.app_env when both APP_ENV and RAILS_ENV are blank": {
        expected: "dev"
      }
    }

    BANNER_TEST_CASES = {
      "when APP_ENV is custom and RAILS_ENV is custom": {
        expected: "foo",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "bar"
        }
      },
      "when both APP_ENV and RAILS_ENV are production": {
        expected: "production",
        env: {
          "APP_ENV" => "production",
          "RAILS_ENV" => "production"
        }
      },
      "when both APP_ENV and RAILS_ENV are development": {
        expected: "development",
        env: {
          "APP_ENV" => "development",
          "RAILS_ENV" => "development"
        }
      },
      "when APP_ENV is present and RAILS_ENV is production": {
        expected: "foo",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "production"
        }
      },
      "when APP_ENV is present and RAILS_ENV is blank": {
        expected: "foo",
        env: {
          "APP_ENV" => "foo"
        }
      },
      "when APP_ENV is blank and RAILS_ENV is present": {
        expected: "foo",
        env: {
          "RAILS_ENV" => "foo"
        }
      },
      "when both APP_ENV and RAILS_ENV are blank": {
        expected: "development" # Default Rails environment
      }
    }

    TEST_CASES.each_key do |name|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
        test "Rails console prompt #{name}" do
          assert_rails_console_prompt(**TEST_CASES[:"#{name}"])
        end
      RUBY
    end

    BANNER_TEST_CASES.each_key do |name|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
        test "Rails console prints Rails.app_env and gem version on start #{name}" do
          assert_rails_console_banner(**BANNER_TEST_CASES[:"#{name}"])
        end
      RUBY
    end

    private

    def assert_rails_console_prompt(expected:, env: {})
      with_pty do
        spawn_console("--sandbox", env: env, wait_for_prompt: true)
        write_prompt "123", prompt: "dummy(#{expected})> "
      end
    end

    def assert_rails_console_banner(expected:, env: {})
      with_pty do
        spawn_console("--sandbox", env: env, wait_for_prompt: false)
        assert_output "Loading #{expected} application environment (rails-app_env #{Rails::AppEnv::VERSION})", @primary
      end
    end
  end
end
