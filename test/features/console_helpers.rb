require "pty"

module ConsoleHelpers
  private

  DUMMY_RAILS = File.expand_path "../../dummy/bin/rails", __FILE__

  def with_pty
    PTY.open do |primary, replica|
      @primary, @replica = primary, replica

      yield
    end
  end

  def spawn_console(options, wait_for_prompt: true, env: {})
    # Test should not depend on user's irbrc file
    home_tmp_dir = Dir.mktmpdir

    env = env.with_defaults(
      "TERM" => "dumb",
      "HOME" => home_tmp_dir,
      "APP_ENV" => nil,
      "RAILS_ENV" => nil,
      "SECRET_KEY_BASE_DUMMY" => "1"
    )

    pid = Process.spawn(
      env,
      "#{DUMMY_RAILS} console #{options}",
      in: @replica, out: @replica, err: @replica
    )

    if wait_for_prompt
      assert_output "> ", @primary
    end

    pid
  ensure
    FileUtils.remove_entry(home_tmp_dir)
  end

  def write_prompt(command, expected_output = nil, prompt: "> ")
    @primary.puts command.to_s
    assert_output command, @primary
    assert_output expected_output, @primary if expected_output
    assert_output prompt, @primary
  end

  def assert_output(expected, io, timeout = 5)
    timeout = Time.current + timeout

    output = +""
    until output.include?(expected) || Time.current > timeout
      if IO.select([io], [], [], 0.1)
        output << io.read(1)
      end
    end

    assert_includes output, expected, "#{expected.inspect} expected, but got:\n\n#{output}"
  end
end
