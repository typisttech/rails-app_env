require_relative "../../../env_helpers"

module Rails::AppEnv::RailtieTest
  class InfoTest < ActiveSupport::TestCase
    include EnvHelpers

    DUMMY_RAILS = File.expand_path "../../../dummy/bin/rails", __dir__

    test "Rails::Info has 'Application environment' defined" do
      assert_includes Rails::Info.properties.names, "Application environment"
    end

    test "rails about command includes 'Application environment' when both APP_ENV and RAILS_ENV are present" do
      switch_env "APP_ENV", "foo" do
        with_rails_env("bar") do
          switch_env "SECRET_KEY_BASE_DUMMY", "1" do
            stdout, status = Open3.capture2(DUMMY_RAILS, "about")

            assert status.success?
            assert_match /Application environment\s+foo/, stdout
          end
        end
      end
    end

    test "rails about command includes 'Application environment' when APP_ENV is present but not RAILS_ENV" do
      switch_env "APP_ENV", "foo" do
        with_rails_env(nil) do
          stdout, status = Open3.capture2(DUMMY_RAILS, "about")

          assert status.success?
          assert_match /Application environment\s+foo/, stdout
        end
      end
    end

    test "rails about command falls back to use Rails.env as 'Application environment' when APP_ENV is blank" do
      switch_env "APP_ENV", nil do
        with_rails_env("foo") do
          switch_env "SECRET_KEY_BASE_DUMMY", "1" do
            stdout, status = Open3.capture2(DUMMY_RAILS, "about")

            assert status.success?
            assert_match /Application environment\s+foo/, stdout
          end
        end
      end
    end

    test "rails about command falls back to use Rails.env as 'Application environment' when both APP_ENV and RAILS_ENV are blank" do
      switch_env "APP_ENV", nil do
        with_rails_env(nil) do
          stdout, status = Open3.capture2(DUMMY_RAILS, "about")

          assert status.success?
          assert_match /Application environment\s+development/, stdout # Default Rails environment
        end
      end
    end
  end
end
