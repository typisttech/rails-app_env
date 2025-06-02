require_relative "../test_helper"
require_relative "env_helpers"

module Rails::AppEnv::FeaturesTest
  class AppEnvTest < ActiveSupport::TestCase
    include EnvHelpers

    test "Rails.app_env is a kind of ActiveSupport::EnvironmentInquirer when APP_ENV is present" do
      with_app_env("foo") do
        assert_kind_of ActiveSupport::EnvironmentInquirer, Rails.app_env
      end
    end

    test "Rails.app_env is a kind of ActiveSupport::EnvironmentInquirer when APP_ENV is blank" do
      with_app_env(nil) do
        assert_kind_of ActiveSupport::EnvironmentInquirer, Rails.app_env
      end
    end

    test "Rails.app_env is an instance of Rails::AppEnv::EnvironmentInquirer when APP_ENV is present" do
      with_app_env("foo") do
        assert_instance_of Rails::AppEnv::EnvironmentInquirer, Rails.app_env
      end
    end

    test "Rails.app_env is set from APP_ENV when both APP_ENV are RAILS_ENV present" do
      with_app_env("foo") do
        with_rails_env("bar") do
          assert_equal "foo", Rails.app_env
          assert_equal "bar", Rails.env
        end
      end
    end

    test "Rails.app_env is set from APP_ENV when APP_ENV is present but RAILS_ENV is blank" do
      with_app_env("foo") do
        with_rails_env(nil) do
          assert_equal "foo", Rails.app_env
          assert_equal DEFAULT_RAILS_ENV, Rails.env
        end
      end
    end

    test "Rails.app_env falls back to Rails.env when APP_ENV is blank but RAILS_ENV is present" do
      with_app_env(nil) do
        with_rails_env("foo") do
          assert_equal "foo", Rails.app_env
          assert_equal "foo", Rails.env
        end
      end
    end

    test "Rails.app_env falls back to default Rails.env when both APP_ENV and RAILS_ENV are blank" do
      with_app_env(nil) do
        with_rails_env(nil) do
          assert_equal DEFAULT_RAILS_ENV, Rails.app_env
          assert_equal DEFAULT_RAILS_ENV, Rails.env
        end
      end
    end

    test "Rails.app_env does not follow Rails.env changes when both APP_ENV and RAILS_ENV are present" do
      with_app_env("foo") do
        with_rails_env("bar") do
          assert_equal "foo", Rails.app_env
          assert_equal "bar", Rails.env

          Rails.env = "baz"

          assert_equal "foo", Rails.app_env
          assert_equal "baz", Rails.env
        end
      end
    end

    test "Rails.app_env does not follow Rails.env changes when APP_ENV is present and RAILS_ENV is blank" do
      with_app_env("foo") do
        with_rails_env(nil) do
          assert_equal "foo", Rails.app_env
          assert_equal DEFAULT_RAILS_ENV, Rails.env

          Rails.env = "bar"

          assert_equal "foo", Rails.app_env
          assert_equal "bar", Rails.env
        end
      end
    end

    test "Rails.app_env does not follow Rails.env changes when APP_ENV is blank but RAILS_ENV is present" do
      with_app_env(nil) do
        with_rails_env("foo") do
          assert_equal "foo", Rails.app_env
          assert_equal "foo", Rails.env

          Rails.env = "bar"

          assert_equal "foo", Rails.app_env
          assert_equal "bar", Rails.env
        end
      end
    end

    test "Rails.app_env does not follow Rails.env changes when both APP_ENV and RAILS_ENV are blank" do
      with_app_env(nil) do
        with_rails_env(nil) do
          assert_equal DEFAULT_RAILS_ENV, Rails.app_env
          assert_equal DEFAULT_RAILS_ENV, Rails.env

          Rails.env = "foo"

          assert_equal DEFAULT_RAILS_ENV, Rails.app_env
          assert_equal "foo", Rails.env
        end
      end
    end
  end
end
