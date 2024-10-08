# frozen_string_literal: true

require "csv"
require "fileutils"

class UsersCsvImportService < ApplicationService
  def initialize(**params)
    super()
    @file_path = params.fetch(:file_path)
  end

  def call
    process_csv!
  end

  private

  def process_csv!
    users = []

    begin
      CSV.foreach(@file_path, headers: true, row_sep: :auto, col_sep: ",", skip_blanks: true) do |row|
        next if row["name"].blank? && row["password"].blank?

        user_instance = process_user_hash(row)
        users << user_instance
      end
    rescue Errno::ENOENT, Errno::EACCES, CSV::MalformedCSVError => e
      Rails.logger.info(e.message)
      raise
    ensure
      FileUtils.rm(@file_path) if @file_path
    end

    instance = import_users(users)
    stream_created_users(instance&.results)
    stream_failed_users(instance&.failed_instances)
  end

  def process_user_hash(row)
    User.new(
      name: row["name"],
      password: row["password"],
    )
  end

  def import_users(users)
    progress = lambda { |_, num_batches, current_batch_number, _|
      progress = (current_batch_number * 100) / num_batches
      Turbo::StreamsChannel.broadcast_append_to(
        "upload_progress",
        target: "uploadProgress",
        partial: "users/progress",
        locals: { progress: progress },
      )
    }
    User.import(
      users,
      batch_size: 2,
      batch_progress: progress,
      returning: [:id, :name, :created_at, :updated_at],
      track_validation_failures: true,
    )
  end

  def stream_created_users(created_users)
    return unless created_users&.size&.positive?

    created_users.each do |user_attributes|
      user = User.new(
        id: user_attributes[0],
        name: user_attributes[1],
        created_at: user_attributes[2],
        updated_at: user_attributes[3],
      )

      Turbo::StreamsChannel.broadcast_append_to(
        "users",
        target: "users",
        partial: "users/user",
        locals: { user: user },
      )
    end
  end

  def stream_failed_users(failed_instances)
    return unless failed_instances&.any?

    failed_instances.each do |(_, user_with_errors)|
      Turbo::StreamsChannel.broadcast_append_to(
        "users_errors",
        target: "users_errors",
        partial: "users/user_error",
        locals: { user: user_with_errors },
      )
    end
  end
end
