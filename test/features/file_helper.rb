module FileHelper
  private

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
