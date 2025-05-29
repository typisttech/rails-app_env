require_relative "../env_helpers"

module RunnerHelper
  include EnvHelpers

  private

  DUMMY_RAILS = File.expand_path "../../dummy/bin/rails", __FILE__

  def assert_runner(expected, subject, app_env: nil, rails_env: nil, secret_key_base_dummy: nil, touch_file: nil, **options)
    switch_env "APP_ENV", app_env do
      with_rails_env(rails_env) do
        switch_env "SECRET_KEY_BASE_DUMMY", secret_key_base_dummy do
          with_file(touch_file) do
            stdout, status = Open3.capture2(DUMMY_RAILS, "runner", "puts #{subject}")

            assert_predicate status, :success?
            assert_equal expected.to_s, stdout.chomp
          end
        end
      end
    end
  end

  def with_file(path, &block)
    return block.call nil if path.nil?

    full_path = Rails.root.join path

    FileUtils.mkdir_p File.dirname(full_path)
    FileUtils.touch full_path

    block.call full_path
  ensure
    FileUtils.rm_f full_path unless full_path.nil?
  end
end
