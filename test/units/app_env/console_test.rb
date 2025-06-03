require "minitest/mock"
require_relative "../../test_helper"
require "rails/commands/console/irb_console"

module Rails::AppEnv
  class ConsoleTest < ActiveSupport::TestCase
    test "Rails::AppEnv::Console is a kind of Rails::Console::IRBConsole" do
      assert_kind_of Rails::Console::IRBConsole, Rails::AppEnv::Console.new(nil)
    end

    test "#colorized_env prints Rails.env only when Rails.app_env is same as Rails.env" do
      Rails.stub :app_env, "foo" do
        Rails.stub :env, "foo" do
          console = Console.new(nil)
          assert_equal_without_color "foo", console.colorized_env
        end
      end
    end

    test "#colorized_env prints {Rails.env:Rails.app_env} when Rails.app_env is diff from Rails.env" do
      Rails.stub :app_env, "foo" do
        Rails.stub :env, "bar" do
          console = Console.new(nil)
          assert_equal_without_color "bar:foo", console.colorized_env
        end
      end
    end

    test "#colorized_env shorten Rails.app_env to prod when Rails.app_env is production" do
      Rails.stub :app_env, "production" do
        Rails.stub :env, "bar" do
          console = Console.new(nil)
          assert_equal_without_color "bar:prod", console.colorized_env
        end
      end
    end

    test "#colorized_env shorten Rails.app_env to dev when Rails.app_env is development" do
      Rails.stub :app_env, "development" do
        Rails.stub :env, "bar" do
          console = Console.new(nil)
          assert_equal_without_color "bar:dev", console.colorized_env
        end
      end
    end

    private

    def assert_equal_without_color(expected, actual)
      assert_equal expected, actual.gsub(/\e\[(\d+)(;\d+)*m/, "")
    end
  end
end
