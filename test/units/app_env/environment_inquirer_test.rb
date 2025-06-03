require_relative "../../test_helper"

module Rails::AppEnv
  class EnvironmentInquirerTest < ActiveSupport::TestCase
    test "EnvironmentInquirer is a kind of ActiveSupport::EnvironmentInquirer" do
      assert_kind_of ActiveSupport::EnvironmentInquirer, Rails::AppEnv::EnvironmentInquirer.new("foo")
    end

    test "#production? is inherited" do
      assert_includes EnvironmentInquirer.instance_methods, :production?
    end

    test "#staging? is defined" do
      assert_includes EnvironmentInquirer.instance_methods, :staging?
    end

    test "#review? is defined" do
      assert_includes EnvironmentInquirer.instance_methods, :review?
    end

    test "#staging?" do
      assert_predicate EnvironmentInquirer.new("staging"), :staging?
      refute_predicate EnvironmentInquirer.new("review"), :staging?
      refute_predicate EnvironmentInquirer.new("production"), :staging?
    end

    test "#review?" do
      refute_predicate EnvironmentInquirer.new("staging"), :review?
      assert_predicate EnvironmentInquirer.new("review"), :review?
      refute_predicate EnvironmentInquirer.new("production"), :review?
    end
  end
end
