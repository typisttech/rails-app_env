require_relative "../test_helper"
require_relative "runner_helpers"
require_relative "file_helpers"

module Rails::AppEnv::FeaturesTest
  class CredentialsTest < ActiveSupport::TestCase
    include RunnerHelpers
    include FileHelpers

    CREDENTIALS_PATH_TEST_CASES = {
      "is {APP_ENV}.yml.enc when both APP_ENV and RAILS_ENV are present": {
        expected_path: "config/credentials/foo.yml.enc",
        touch_file: "config/credentials/foo.yml.enc",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "bar"
        }
      },
      "falls back to credentials.yml.enc when {APP_ENV}.yml.enc is absent and both APP_ENV and RAILS_ENV are present": {
        expected_path: "config/credentials.yml.enc",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "bar"
        }
      },
      "is {APP_ENV}.yml.enc when APP_ENV is present but RAILS_ENV is blank": {
        expected_path: "config/credentials/foo.yml.enc",
        touch_file: "config/credentials/foo.yml.enc",
        env: {
          "APP_ENV" => "foo"
        }
      },
      "falls back to credentials.yml.enc when {APP_ENV}.yml.enc is absent and APP_ENV is present but RAILS_ENV is blank": {
        expected_path: "config/credentials.yml.enc",
        env: {
          "APP_ENV" => "foo"
        }
      },
      "is {RAILS_ENV}.yml.enc when APP_ENV is blank but RAILS_ENV is present": {
        expected_path: "config/credentials/foo.yml.enc",
        touch_file: "config/credentials/foo.yml.enc",
        env: {
          "RAILS_ENV" => "foo"
        }
      },
      "falls back to credentials.yml.enc when {RAILS_ENV}.yml.enc is absent and when APP_ENV is blank but RAILS_ENV is present": {
        expected_path: "config/credentials.yml.enc",
        env: {
          "RAILS_ENV" => "foo"
        }
      },
      "is {DEFAULT_RAILS_ENV}.yml.enc when both APP_ENV and RAILS_ENV are blank": {
        expected_path: "config/credentials/#{DEFAULT_RAILS_ENV}.yml.enc",
        touch_file: "config/credentials/#{DEFAULT_RAILS_ENV}.yml.enc"
      },
      "falls back to credentials.yml.enc when {DEFAULT_RAILS_ENV}.yml.enc is absent and both APP_ENV and RAILS_ENV are blank": {
        expected_path: "config/credentials.yml.enc"
      }
    }

    KEY_PATH_TEST_CASES = {
      "is {APP_ENV}.key when both APP_ENV and RAILS_ENV are present": {
        expected_path: "config/credentials/foo.key",
        touch_file: "config/credentials/foo.key",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "bar"
        }
      },
      "falls back to master.key when {APP_ENV}.key is absent and both APP_ENV and RAILS_ENV are present": {
        expected_path: "config/master.key",
        env: {
          "APP_ENV" => "foo",
          "RAILS_ENV" => "bar"
        }
      },
      "is {APP_ENV}.key when APP_ENV is present but RAILS_ENV is blank": {
        expected_path: "config/credentials/foo.key",
        touch_file: "config/credentials/foo.key",
        env: {
          "APP_ENV" => "foo"
        }
      },
      "falls back to master.key when {APP_ENV}.key is absent and APP_ENV is present but RAILS_ENV is blank": {
        expected_path: "config/master.key",
        env: {
          "APP_ENV" => "foo"
        }
      },
      "is {RAILS_ENV}.key when APP_ENV is blank but RAILS_ENV is present": {
        expected_path: "config/credentials/foo.key",
        touch_file: "config/credentials/foo.key",
        env: {
          "RAILS_ENV" => "foo"
        }
      },
      "falls back to master.key when {RAILS_ENV}.key is absent and when APP_ENV is blank but RAILS_ENV is present": {
        expected_path: "config/master.key",
        env: {
          "RAILS_ENV" => "foo"
        }
      },
      "is {DEFAULT_RAILS_ENV}.key when both APP_ENV and RAILS_ENV are blank": {
        expected_path: "config/credentials/#{DEFAULT_RAILS_ENV}.key",
        touch_file: "config/credentials/#{DEFAULT_RAILS_ENV}.key"
      },
      "falls back to master.key when {DEFAULT_RAILS_ENV}.key is absent and both APP_ENV and RAILS_ENV are blank": {
        expected_path: "config/master.key"
      }
    }

    CREDENTIALS_PATH_TEST_CASES.each_key do |name|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
        test "content path  #{name}" do
          assert_credentials_path(**CREDENTIALS_PATH_TEST_CASES[:"#{name}"])
        end
      RUBY
    end

    KEY_PATH_TEST_CASES.each_key do |name|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
        test "key path  #{name}" do
          assert_key_path(**KEY_PATH_TEST_CASES[:"#{name}"])
        end
      RUBY
    end

    private

    def assert_credentials_path(expected_path:, touch_file: nil, **options)
      assert_runner_puts_with_file dummy_path(expected_path), "Rails.configuration.credentials.content_path", touch_file, **options
    end

    def assert_key_path(expected_path:, touch_file: nil, **options)
      assert_runner_puts_with_file dummy_path(expected_path), "Rails.configuration.credentials.key_path", touch_file, **options
    end

    def assert_runner_puts_with_file(expected, subject, file_path, **options)
      with_file(file_path) do
        assert_runner_puts expected, subject, **options
      end
    end
  end
end
