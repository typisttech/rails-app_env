require "minitest/mock"

class Rails::AppEnv::CredentialsTest < ActiveSupport::TestCase
  test "Credentials#content_path returns 'config/credentials/{APP_ENV}.yml.enc' if the file exist" do
    Dir.mktmpdir do |tmp_dir|
      Rails.stub :root, Pathname(tmp_dir) do
        Rails.stub :app_env, Rails::AppEnv::EnvironmentInquirer.new("fake_foo") do
          path = Rails.root.join("config/credentials/fake_foo.yml.enc")

          FileUtils.mkdir_p File.dirname(path)
          FileUtils.touch path

          assert_equal path, Rails::AppEnv::Credentials.content_path
        end
      end
    end
  end

  test "Credentials#content_path falls back to 'config/credentials.yml.enc' if the file does not exist" do
    Dir.mktmpdir do |tmp_dir|
      Rails.stub :root, Pathname(tmp_dir) do
        Rails.stub :app_env, Rails::AppEnv::EnvironmentInquirer.new("fake_foo") do
          path = Rails.root.join("config/credentials.yml.enc")

          assert_equal path, Rails::AppEnv::Credentials.content_path
        end
      end
    end
  end

  test "Credentials#key_path returns 'config/credentials/{APP_ENV}.key' if the file exist" do
    Dir.mktmpdir do |tmp_dir|
      Rails.stub :root, Pathname(tmp_dir) do
        Rails.stub :app_env, Rails::AppEnv::EnvironmentInquirer.new("fake_foo") do
          path = Rails.root.join("config/credentials/fake_foo.key")

          FileUtils.mkdir_p File.dirname(path)
          FileUtils.touch path

          assert_equal path, Rails::AppEnv::Credentials.key_path
        end
      end
    end
  end

  test "Credentials#key_path falls back to 'config/master.key' if the file does not exist" do
    Dir.mktmpdir do |tmp_dir|
      Rails.stub :root, Pathname(tmp_dir) do
        Rails.stub :app_env, Rails::AppEnv::EnvironmentInquirer.new("fake_foo") do
          path = Rails.root.join("config/master.key")

          assert_equal path, Rails::AppEnv::Credentials.key_path
        end
      end
    end
  end
end
