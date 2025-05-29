require_relative "../test_helper"

class Rails::AppEnvTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Rails::AppEnv::VERSION
  end
end
