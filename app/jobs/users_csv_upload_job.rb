# frozen_string_literal: true

require "net/http"
require "tempfile"

class UsersCsvUploadJob < ApplicationJob
  include Sidekiq::Status::Worker

  queue_as :users_csv_upload

  sidekiq_options timeout: 300000, retry: 5

  def perform(**params)
    string_file_url = params.fetch(:string_file_path)
    temp_file = Tempfile.new(["users", ".csv"])

    begin
      download_file(string_file_url, temp_file.path)
      UsersCsvImportService.call(file_path: temp_file.path)
    rescue StandardError => e
      Rails.logger.error("An error occurred: #{e.message}")
      raise
    ensure
      temp_file.close
      temp_file.unlink
    end
  end

  private

  def download_file(url, output_path)
    File.open(output_path, "wb") do |file|
      file.write(Net::HTTP.get(URI.parse(url)))
    end
  end
end
