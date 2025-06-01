module RunnerHelpers
  private

  def assert_runner_puts(expected, subject, env: {})
    env = env.with_defaults({"APP_ENV" => nil, "RAILS_ENV" => nil})

    stdout, status = Open3.capture2(env, "#{DUMMY_ROOT}/bin/rails", "runner", "puts #{subject}")

    assert_predicate status, :success?
    assert_equal expected.to_s, stdout.chomp
  end
end
