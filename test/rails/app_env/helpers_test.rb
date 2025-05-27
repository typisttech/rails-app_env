require_relative "../../env_helpers"

class Rails::AppEnvTest < ActiveSupport::TestCase
  include EnvHelpers

  DEFAULT_RAILS_ENV = "development"

  test "Rails.app_env is an instance of EnvironmentInquirer when APP_ENV is present" do
    switch_env "APP_ENV", nil do
      assert_instance_of ActiveSupport::EnvironmentInquirer, Rails.app_env
    end
  end

  test "Rails.app_env is an instance of EnvironmentInquirer when APP_ENV is blank" do
    switch_env "APP_ENV", "foo" do
      assert_instance_of ActiveSupport::EnvironmentInquirer, Rails.app_env
    end
  end

  test "Rails.app_env is set from APP_ENV" do
    switch_env "APP_ENV", "foo" do
        assert_equal "foo", Rails.app_env
    end
  end

  test "Rails.app_env is set from APP_ENV when both APP_ENV are RAILS_ENV present" do
    switch_env "APP_ENV", "foo" do
      with_rails_env("bar") do
        assert_equal "foo", Rails.app_env
        assert_equal "bar", Rails.env
      end
    end
  end

  test "Rails.app_env is set from APP_ENV when APP_ENV is present but not RAILS_ENV" do
    switch_env "APP_ENV", "foo" do
      with_rails_env(nil) do
        assert_equal "foo", Rails.app_env
        assert_equal DEFAULT_RAILS_ENV, Rails.env # Default Rails environment
      end
    end
  end

  test "Rails.app_env falls back to Rails.env when APP_ENV is blank" do
    switch_env "APP_ENV", nil do
      with_rails_env("foo") do
        assert_equal "foo", Rails.app_env
        assert_equal "foo", Rails.env
        assert_same Rails.env, Rails.app_env
      end
    end
  end

  test "Rails.app_env falls back to Rails.env when APP_ENV is blank and follow its changes" do
    switch_env "APP_ENV", nil do
      with_rails_env("foo") do
        Rails.env = "bar"

        assert_equal "bar", Rails.app_env
        assert_equal "bar", Rails.env
        assert_same Rails.env, Rails.app_env
      end
    end
  end

  test "Rails.app_env falls back to Rails.env when both APP_ENV and RAILS_ENV are blank" do
    switch_env "APP_ENV", nil do
      with_rails_env(nil) do
        assert_equal DEFAULT_RAILS_ENV, Rails.app_env
        assert_equal DEFAULT_RAILS_ENV, Rails.env # Default Rails environment
        assert_same Rails.env, Rails.app_env
      end
    end
  end

  test "Rails.app_env falls back to Rails.env when both APP_ENV and RAILS_ENV are blank and follow its changes" do
    switch_env "APP_ENV", nil do
      with_rails_env(nil) do
        Rails.env = "foo"

        assert_equal "foo", Rails.app_env
        assert_equal "foo", Rails.env
        assert_same Rails.env, Rails.app_env
      end
    end
  end

  test "Rails.app_env is set from APP_ENV and does not follow Rails.env changes" do
    switch_env "APP_ENV", "foo" do
      with_rails_env("bar") do
        Rails.env = "baz"

        assert_equal "foo", Rails.app_env
        assert_equal "baz", Rails.env
      end
    end
  end
end
