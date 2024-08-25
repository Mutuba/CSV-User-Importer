# frozen_string_literal: true

class UsersCsvFileWriterService < ApplicationService
  def initialize(file:)
    super()
    @file = file
  end

  def call
    file_path = save_temp_file(@file)
    enqueue_job(file_path)
  end

  private

  def save_temp_file(file)
    temp_file = Tempfile.new([file.original_filename, File.extname(file.original_filename)])
    temp_file.binmode
    temp_file.write(file.read)
    temp_file.close
    temp_file.path
  rescue StandardError => e
    handle_error("IO error while saving temporary file: #{e.message}")
  end

  def enqueue_job(file_path)
    UsersCsvUploadJob.perform_later(string_file_path: file_path)
  end

  def handle_error(message)
    Rails.logger.error(message)
    raise
  end
end
