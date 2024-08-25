# frozen_string_literal: true

class CsvFileUploadService < ApplicationService
  SuccessStruct = Struct.new(:file_url, :public_id, :success?)
  FailureStruct = Struct.new(:error, :failure?, :success?)

  def initialize(file:)
    super()
    @file = file
  end

  def call
    upload_file
    results
    enqueue_job
  end

  private

  def upload_file
    @response = Cloudinary::Uploader.upload(
      @file.path,
      resource_type: :raw,
      use_filename: true,
      unique_filename: false,
      overwrite: true,
    )
  rescue CloudinaryException => e
    Rails.logger.error("Cloudinary upload failed: #{e.message}")
    @response = { "error" => e.message }
  rescue => e
    Rails.logger.error("Unexpected error during file upload: #{e.message}")
    @response = { "error" => e.message }
  end

  def result
    if @response["error"]
      FailureStruct.new(@response["error"], true, false)
    else
      SuccessStruct.new(@response["url"], @response["public_id"], true)
    end
  end

  def results
    result
  end

  def enqueue_job
    if results.success?
      UsersCsvUploadJob.perform_later(string_file_path: result.file_url)
    end
  end
end
