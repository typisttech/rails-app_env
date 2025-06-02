module FileHelpers
  private

  def with_file(relative, &block)
    return block.call nil if relative.nil?

    full_path = dummy_path(relative)

    FileUtils.mkdir_p File.dirname(full_path)
    FileUtils.touch full_path

    block.call full_path
  ensure
    FileUtils.rm_f full_path unless full_path.nil?
  end

  def assert_files(relatives, message = "")
    relatives.each do |relative|
      assert_file relative, message
    end
  end

  def refute_files(relatives, message = "")
    relatives.each do |relative|
      refute_file relative, message
    end
  end

  def assert_file(relative, message = "")
    assert File.exist?(dummy_path(relative)), ["Expected file #{relative.inspect} to exist, but it does", message.strip].join(" ").strip
  end

  def refute_file(relative, message = "")
    refute File.exist?(dummy_path(relative)), ["Expected file #{relative.inspect} to not exist, but it does", message.strip].join(" ").strip
  end

  def dummy_path(relative)
    File.expand_path(relative, DUMMY_ROOT)
  end
end
