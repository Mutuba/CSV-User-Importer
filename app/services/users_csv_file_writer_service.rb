# frozen_string_literal: true

class UsersCsvFileWriterService < ApplicationService
  def initialize(file:, base_url:)
    super()
    @file = file
    @base_url = base_url
  end

  def call
    file_path = generate_file_path
    write_file(file_path)
    enqueue_job(file_path)
  end

  private

  def generate_file_path
    Rails.root.join("lib", "user-import-#{SecureRandom.uuid}.csv")
  end

  def write_file(file_path)
    File.write(file_path, @file.read)
  rescue Errno::EACCES => e
    handle_error("Permission denied: #{e.message}")
  rescue Errno::ENOENT => e
    handle_error("File not found: #{e.message}")
  rescue Errno::ENOSPC => e
    handle_error("Disk full: #{e.message}")
  rescue Encoding::UndefinedConversionError => e
    handle_error("Encoding error: #{e.message}")
  rescue Encoding::InvalidByteSequenceError => e
    handle_error("Encoding error: #{e.message}")
  rescue StandardError => e
    handle_error("IO error: #{e.message}")
  end

  def enqueue_job(file_path)
    UsersCsvUploadJob.perform_later(
      string_file_path: file_path.to_path,
      base_url: @base_url,
    )
  end

  def handle_error(message)
    Rails.logger.error(message)
    raise
  end
end
