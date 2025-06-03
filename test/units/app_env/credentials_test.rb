require "minitest/mock"
require_relative "../../test_helper"

class Rails::AppEnv::CredentialsTest < ActiveSupport::TestCase
  test "Rails::AppEnv::Credentials::AlreadyInitializedError is a kind of Rails::AppEnv::Error" do
    assert_kind_of Rails::AppEnv::Error, Rails::AppEnv::Credentials::AlreadyInitializedError.new
  end

  test "#initialize! can only be invoked once" do
    reset_credentials

    Rails::AppEnv::Credentials.initialize!

    assert_raises Rails::AppEnv::Credentials::AlreadyInitializedError do
      Rails::AppEnv::Credentials.initialize!
    end
  end

  test "#initialize! backup original Rails.application.config.credentials" do
    reset_credentials

    expected = Object.new

    Rails.application.config.stub :credentials, expected do
      Rails::AppEnv::Credentials.initialize!
    end

    assert_same expected, Rails::AppEnv::Credentials.original
  end

  test "#configuration is a kind of ActiveSupport::Credentials" do
    assert_kind_of ActiveSupport::InheritableOptions, Rails::AppEnv::Credentials.configuration
  end

  test "#configuration.content_path is config/credentials/{Rails.app_env}.yml.enc" do
    Dir.mktmpdir do |tmp_dir|
      Rails.stub :root, Pathname(tmp_dir) do
        Rails.stub :app_env, Rails::AppEnv::EnvironmentInquirer.new("foo") do
          path = Rails.root.join("config/credentials/foo.yml.enc")

          FileUtils.mkdir_p File.dirname(path)
          FileUtils.touch path

          assert_equal path, Rails::AppEnv::Credentials.configuration.content_path
        end
      end
    end
  end

  test "#configuration.content_path falls back to config/credentials.yml.enc when config/credentials/{Rails.app_env}.yml.enc not exist" do
    Dir.mktmpdir do |tmp_dir|
      Rails.stub :root, Pathname(tmp_dir) do
        Rails.stub :app_env, Rails::AppEnv::EnvironmentInquirer.new("foo") do
          path = Rails.root.join("config/credentials.yml.enc")

          assert_equal path, Rails::AppEnv::Credentials.configuration.content_path
        end
      end
    end
  end

  test "#configuration.key_path is config/credentials/{APP_ENV}.key" do
    Dir.mktmpdir do |tmp_dir|
      Rails.stub :root, Pathname(tmp_dir) do
        Rails.stub :app_env, Rails::AppEnv::EnvironmentInquirer.new("foo") do
          path = Rails.root.join("config/credentials/foo.key")

          FileUtils.mkdir_p File.dirname(path)
          FileUtils.touch path

          assert_equal path, Rails::AppEnv::Credentials.configuration.key_path
        end
      end
    end
  end

  test "#configuration.key_path falls back to config/master.key when config/credentials/{APP_ENV}.key not exist" do
    Dir.mktmpdir do |tmp_dir|
      Rails.stub :root, Pathname(tmp_dir) do
        Rails.stub :app_env, Rails::AppEnv::EnvironmentInquirer.new("foo") do
          path = Rails.root.join("config/master.key")

          assert_equal path, Rails::AppEnv::Credentials.configuration.key_path
        end
      end
    end
  end

  private

  def reset_credentials
    Rails::AppEnv::Credentials.instance_variable_set :@initialized, nil
    Rails::AppEnv::Credentials.instance_variable_set :@original, nil
  end
end
