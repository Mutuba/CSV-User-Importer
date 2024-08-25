# frozen_string_literal: true

class UsersCsvUploadJob < ApplicationJob
  include Sidekiq::Status::Worker

  queue_as :users_csv_upload

  sidekiq_options timeout: 300, retry: 5

  def perform(**params)
    string_file_path = params.fetch(:string_file_path)
    base_url = params.fetch(:base_url)

    begin
      file_path = Rails.root.join(string_file_path)
      UsersCsvImportService.call(file_path:, base_url:)
    rescue StandardError => e
      Rails.logger.error("An error occurred: #{e.message}")
      raise
    end
  end
end
