require_relative "../test_helper"
require_relative "runner_helper"

module Rails::AppEnv::FeaturesTest
  class CredentialsTest < ActiveSupport::TestCase
    include RunnerHelper

    CREDENTIALS_PATH_TEST_CASES = [
      {
        name: "is {APP_ENV}.yml.enc when both APP_ENV and RAILS_ENV are present",
        expected_path: "config/credentials/foo.yml.enc",
        app_env: "foo",
        rails_env: "bar",
        secret_key_base_dummy: "1",
        touch_file: "config/credentials/foo.yml.enc"
      },
      {
        name: "falls back to credentials.yml.enc when {APP_ENV}.yml.enc is absent and both APP_ENV and RAILS_ENV are present",
        expected_path: "config/credentials.yml.enc",
        app_env: "foo",
        rails_env: "bar",
        secret_key_base_dummy: "1"
      },
      {
        name: "is {APP_ENV}.yml.enc when APP_ENV is present but RAILS_ENV is blank",
        expected_path: "config/credentials/foo.yml.enc",
        app_env: "foo",
        touch_file: "config/credentials/foo.yml.enc"
      },
      {
        name: "falls back to credentials.yml.enc when {APP_ENV}.yml.enc is absent and APP_ENV is present but RAILS_ENV is blank",
        expected_path: "config/credentials.yml.enc",
        app_env: "foo",
        secret_key_base_dummy: "1"
      },
      {
        name: "is {RAILS_ENV}.yml.enc when APP_ENV is blank but RAILS_ENV is present",
        expected_path: "config/credentials/foo.yml.enc",
        rails_env: "foo",
        secret_key_base_dummy: "1",
        touch_file: "config/credentials/foo.yml.enc"
      },
      {
        name: "falls back to credentials.yml.enc when {RAILS_ENV}.yml.enc is absent and when APP_ENV is blank but RAILS_ENV is present",
        expected_path: "config/credentials.yml.enc",
        rails_env: "foo",
        secret_key_base_dummy: "1"
      },
      {
        name: "is {DEFAULT_RAILS_ENV}.yml.enc when both APP_ENV and RAILS_ENV are blank",
        expected_path: "config/credentials/#{DEFAULT_RAILS_ENV}.yml.enc",
        touch_file: "config/credentials/#{DEFAULT_RAILS_ENV}.yml.enc"
      },
      {
        name: "falls back to credentials.yml.enc when {DEFAULT_RAILS_ENV}.yml.enc is absent and both APP_ENV and RAILS_ENV are blank",
        expected_path: "config/credentials.yml.enc"
      }
    ]

    KEY_PATH_TEST_CASES = [
      {
        name: "is {APP_ENV}.key when both APP_ENV and RAILS_ENV are present",
        expected_path: "config/credentials/foo.key",
        app_env: "foo",
        rails_env: "bar",
        secret_key_base_dummy: "1",
        touch_file: "config/credentials/foo.key"
      },
      {
        name: "falls back to master.key when {APP_ENV}.key is absent and both APP_ENV and RAILS_ENV are present",
        expected_path: "config/master.key",
        app_env: "foo",
        rails_env: "bar",
        secret_key_base_dummy: "1"
      },
      {
        name: "is {APP_ENV}.key when APP_ENV is present but RAILS_ENV is blank",
        expected_path: "config/credentials/foo.key",
        app_env: "foo",
        touch_file: "config/credentials/foo.key"
      },
      {
        name: "falls back to master.key when {APP_ENV}.key is absent and APP_ENV is present but RAILS_ENV is blank",
        expected_path: "config/master.key",
        app_env: "foo"
      },
      {
        name: "is {RAILS_ENV}.key when APP_ENV is blank but RAILS_ENV is present",
        expected_path: "config/credentials/foo.key",
        rails_env: "foo",
        touch_file: "config/credentials/foo.key",
        secret_key_base_dummy: "1"
      },
      {
        name: "falls back to master.key when {RAILS_ENV}.key is absent and when APP_ENV is blank but RAILS_ENV is present",
        expected_path: "config/master.key",
        rails_env: "foo",
        secret_key_base_dummy: "1"
      },
      {
        name: "is {DEFAULT_RAILS_ENV}.key when both APP_ENV and RAILS_ENV are blank",
        expected_path: "config/credentials/#{DEFAULT_RAILS_ENV}.key",
        touch_file: "config/credentials/#{DEFAULT_RAILS_ENV}.key"
      },
      {
        name: "falls back to master.key when {DEFAULT_RAILS_ENV}.key is absent and both APP_ENV and RAILS_ENV are blank",
        expected_path: "config/master.key"
      }
    ]

    CREDENTIALS_PATH_TEST_CASES.each_with_index do |args, i|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
        test "content path #{args[:name]}" do
          assert_credentials_path(**CREDENTIALS_PATH_TEST_CASES[#{i}])
        end
      RUBY
    end

    KEY_PATH_TEST_CASES.each_with_index do |args, i|
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
        test "key path #{args[:name]}" do
          assert_key_path(**KEY_PATH_TEST_CASES[#{i}])
        end
      RUBY
    end

    private

    def assert_credentials_path(expected_path:, **options)
      assert_runner Rails.root.join(expected_path), "Rails.configuration.credentials.content_path", **options
    end

    def assert_key_path(expected_path:, **options)
      assert_runner Rails.root.join(expected_path), "Rails.configuration.credentials.key_path", **options
    end
  end
end
