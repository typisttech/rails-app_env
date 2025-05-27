class Rails::AppEnv::EnvironmentInquirerTest < ActiveSupport::TestCase
  test "EnvironmentInquirer is a kind of ActiveSupport::EnvironmentInquirer" do
    assert_kind_of ActiveSupport::EnvironmentInquirer, Rails::AppEnv::EnvironmentInquirer.new("foo")
  end

  test "EnvironmentInquirer#production? is inherited" do
    assert_includes Rails::AppEnv::EnvironmentInquirer.instance_methods, :production?
  end

  test "EnvironmentInquirer#staging? is defined" do
    assert_includes Rails::AppEnv::EnvironmentInquirer.instance_methods, :staging?
  end

  test "EnvironmentInquirer#review? is defined" do
    assert_includes Rails::AppEnv::EnvironmentInquirer.instance_methods, :review?
  end

  test "EnvironmentInquirer#staging?" do
    assert_predicate Rails::AppEnv::EnvironmentInquirer.new("staging"), :staging?
    refute_predicate Rails::AppEnv::EnvironmentInquirer.new("review"), :staging?
    refute_predicate Rails::AppEnv::EnvironmentInquirer.new("production"), :staging?
  end

  test "EnvironmentInquirer#review?" do
    refute_predicate Rails::AppEnv::EnvironmentInquirer.new("staging"), :review?
    assert_predicate Rails::AppEnv::EnvironmentInquirer.new("review"), :review?
    refute_predicate Rails::AppEnv::EnvironmentInquirer.new("production"), :review?
  end
end
