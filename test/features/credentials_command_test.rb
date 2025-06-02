require_relative "../test_helper"
require_relative "file_helpers"

module Rails::AppEnv::FeaturesTest
  class CredentialsCommandTest < ActiveSupport::TestCase
    include FileHelpers

    def setup
      cleanup_credentials_files
    end

    def teardown
      cleanup_credentials_files
    end

    test "does not override when --environment is custom" do
      arg_env = "foo"

      ["foo", "production", "development", "test", nil].each do |app_env|
        ["foo", "production", "development", "test", nil].each do |rails_env|
          cleanup_credentials_files

          run_edit_command(app_env:, rails_env:, arg_env:)

          refute_files %w[
            config/credentials.yml.enc
            config/master.key
            config/credentials/production.yml.enc
            config/credentials/production.key
            config/credentials/development.yml.enc
            config/credentials/development.key
            config/credentials/test.yml.enc
            config/credentials/test.key
            config/credentials/.yml.enc
            config/credentials/.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"

          assert_files %w[
            config/credentials/foo.yml.enc
            config/credentials/foo.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"
        end
      end
    end

    test "does not override when --environment is production" do
      arg_env = "production"

      ["foo", "production", "development", "test", nil].each do |app_env|
        ["foo", "production", "development", "test", nil].each do |rails_env|
          cleanup_credentials_files

          run_edit_command(app_env:, rails_env:, arg_env:)

          refute_files %w[
            config/credentials.yml.enc
            config/master.key
            config/credentials/foo.yml.enc
            config/credentials/foo.key
            config/credentials/development.yml.enc
            config/credentials/development.key
            config/credentials/test.yml.enc
            config/credentials/test.key
            config/credentials/.yml.enc
            config/credentials/.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"

          assert_files %w[
            config/credentials/production.yml.enc
            config/credentials/production.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"
        end
      end
    end

    test "does not override when --environment is development" do
      arg_env = "development"

      ["foo", "production", "development", "test", nil].each do |app_env|
        ["foo", "production", "development", "test", nil].each do |rails_env|
          cleanup_credentials_files

          run_edit_command(app_env:, rails_env:, arg_env:)

          refute_files %w[
            config/credentials.yml.enc
            config/master.key
            config/credentials/foo.yml.enc
            config/credentials/foo.key
            config/credentials/production.yml.enc
            config/credentials/production.key
            config/credentials/test.yml.enc
            config/credentials/test.key
            config/credentials/.yml.enc
            config/credentials/.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"

          assert_files %w[
            config/credentials/development.yml.enc
            config/credentials/development.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"
        end
      end
    end

    test "does not override when --environment is test" do
      arg_env = "test"

      ["foo", "production", "development", "test", nil].each do |app_env|
        ["foo", "production", "development", "test", nil].each do |rails_env|
          cleanup_credentials_files

          run_edit_command(app_env:, rails_env:, arg_env:)

          refute_files %W[
            config/credentials.yml.enc
            config/master.key
            config/credentials/foo.yml.enc
            config/credentials/foo.key
            config/credentials/production.yml.enc
            config/credentials/production.key
            config/credentials/development.yml.enc
            config/credentials/development.key
            config/credentials/.yml.enc
            config/credentials/.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"

          assert_files %w[
            config/credentials/test.yml.enc
            config/credentials/test.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"
        end
      end
    end

    test "does not override when --environment are blank" do
      arg_env = nil

      ["foo", "production", "development", "test", nil].each do |app_env|
        ["foo", "production", "development", "test", nil].each do |rails_env|
          cleanup_credentials_files

          run_edit_command(app_env:, rails_env:, arg_env:)

          refute_files %w[
            config/credentials/foo.yml.enc
            config/credentials/foo.key
            config/credentials/production.yml.enc
            config/credentials/production.key
            config/credentials/development.yml.enc
            config/credentials/development.key
            config/credentials/test.yml.enc
            config/credentials/test.key
            config/credentials/.yml.enc
            config/credentials/.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"

          assert_files %w[
            config/credentials.yml.enc
            config/master.key
          ], "when APP_ENV is #{app_env.inspect} and RAILS_ENV is #{rails_env.inspect} and arg_env is #{arg_env.inspect}"
        end
      end
    end

    private

    def run_edit_command(arg_env: nil, app_env: nil, rails_env: nil)
      env = {"VISUAL" => "cat", "EDITOR" => "cat", "APP_ENV" => app_env, "RAILS_ENV" => rails_env}
      args = arg_env ? ["--environment", arg_env] : []

      _, status = Open3.capture2(env, "bin/rails", "credentials:edit", *args, {chdir: DUMMY_ROOT})

      assert_predicate status, :success?
    end

    def cleanup_credentials_files
      FileUtils.remove_dir dummy_path("config/credentials"), true
      FileUtils.remove_file dummy_path("config/credentials.yml.enc"), true
      FileUtils.remove_file dummy_path("config/master.key"), true
    end
  end
end
