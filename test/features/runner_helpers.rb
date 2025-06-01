module RunnerHelpers
  private

  DUMMY_RAILS = File.expand_path "../../dummy/bin/rails", __FILE__

  def assert_runner_puts(expected, subject, env: {})
    env = env.with_defaults({"APP_ENV" => nil, "RAILS_ENV" => nil, "SECRET_KEY_BASE_DUMMY" => "1"})

    stdout, status = Open3.capture2(env, DUMMY_RAILS, "runner", "puts #{subject}")

    assert_predicate status, :success?
    assert_equal expected.to_s, stdout.chomp
  end
end
