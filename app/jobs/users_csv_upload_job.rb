# frozen_string_literal: true

# UsersCsvUploadJob
class UsersCsvUploadJob < ApplicationJob
  include Sidekiq::Status::Worker
  queue_as :default

  sidekiq_options lock: :until_executed,
    on_conflict: :reject

  def perform(**params)
    params.fetch(:string_file_path)
    params.fetch(:base_url)

    # begin
    #   file_path = Rails.root.join(string_file_path)
    #   UrlsCsvBatchUploadService.call(file_path:, base_url:,
    #                                  current_user:)
    # rescue StandardError => e
    #   Rails.logger.error("An error occurred: #{e.message}")
    # end
  end
end
