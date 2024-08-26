# frozen_string_literal: true

class CsvFileUploadService < ApplicationService
  SuccessStruct = Struct.new(:file_url, :public_id) do
    def success?
      true
    end
  end

  FailureStruct = Struct.new(:error) do
    def success?
      false
    end
  end

  def initialize(file:)
    super()
    @file = file
  end

  def call
    response = upload_file
    result = build_result(response)
    enqueue_job(result) if result.success?
    result
  end

  private

  def upload_file
    file_path = @file.respond_to?(:path) ? @file.path : @file.to_s
    Cloudinary::Uploader.upload(
      file_path,
      resource_type: :raw,
      use_filename: true,
      unique_filename: false,
      overwrite: true,
    )
  rescue CloudinaryException => e
    { "error" => e.message }
  rescue => e
    { "error" => e.message }
  end

  def build_result(response)
    if response["error"]
      FailureStruct.new(response["error"])
    else
      SuccessStruct.new(response["url"], response["public_id"])
    end
  end

  def enqueue_job(result)
    UsersCsvUploadJob.perform_later(string_file_path: result.file_url)
  end
end
