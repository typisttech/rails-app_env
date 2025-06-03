require "minitest/mock"
require_relative "../../test_helper"

module Rails::AppEnv
  class CredentialsTest < ActiveSupport::TestCase
    test "Rails::AppEnv::Credentials::AlreadyInitializedError is a kind of Rails::AppEnv::Error" do
      assert_kind_of Rails::AppEnv::Error, Rails::AppEnv::Credentials::AlreadyInitializedError.new
    end

    test ".initialize! can only be invoked once" do
      reset_credentials

      Credentials.initialize!

      assert_raises Rails::AppEnv::Credentials::AlreadyInitializedError do
        Credentials.initialize!
      end
    end

    test ".initialize! backup original Rails.application.config.credentials" do
      reset_credentials

      expected = Object.new

      Rails.application.config.stub :credentials, expected do
        Credentials.initialize!
      end

      assert_same expected, Credentials.original
    end

    test ".configuration is a kind of ActiveSupport::Credentials" do
      assert_kind_of ActiveSupport::InheritableOptions, Credentials.configuration
    end

    test ".configuration.content_path is config/credentials/{Rails.app_env}.yml.enc" do
      Dir.mktmpdir do |tmp_dir|
        Rails.stub :root, Pathname(tmp_dir) do
          Rails.stub :app_env, EnvironmentInquirer.new("foo") do
            path = Rails.root.join("config/credentials/foo.yml.enc")

            FileUtils.mkdir_p File.dirname(path)
            FileUtils.touch path

            assert_equal path, Credentials.configuration.content_path
          end
        end
      end
    end

    test ".configuration.content_path falls back to config/credentials.yml.enc when config/credentials/{Rails.app_env}.yml.enc not exist" do
      Dir.mktmpdir do |tmp_dir|
        Rails.stub :root, Pathname(tmp_dir) do
          Rails.stub :app_env, EnvironmentInquirer.new("foo") do
            path = Rails.root.join("config/credentials.yml.enc")

            assert_equal path, Credentials.configuration.content_path
          end
        end
      end
    end

    test ".configuration.key_path is config/credentials/{APP_ENV}.key" do
      Dir.mktmpdir do |tmp_dir|
        Rails.stub :root, Pathname(tmp_dir) do
          Rails.stub :app_env, EnvironmentInquirer.new("foo") do
            path = Rails.root.join("config/credentials/foo.key")

            FileUtils.mkdir_p File.dirname(path)
            FileUtils.touch path

            assert_equal path, Credentials.configuration.key_path
          end
        end
      end
    end

    test ".configuration.key_path falls back to config/master.key when config/credentials/{APP_ENV}.key not exist" do
      Dir.mktmpdir do |tmp_dir|
        Rails.stub :root, Pathname(tmp_dir) do
          Rails.stub :app_env, EnvironmentInquirer.new("foo") do
            path = Rails.root.join("config/master.key")

            assert_equal path, Credentials.configuration.key_path
          end
        end
      end
    end

    private

    def reset_credentials
      Credentials.instance_variable_set :@initialized, nil
      Credentials.instance_variable_set :@original, nil
    end
  end
end
