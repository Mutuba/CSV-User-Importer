# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all.order(created_at: :desc)
    @users_errors = []

    respond_to do |format|
      format.html
      format.json { render(json: @users) }
    end
  end

  def create
    return handle_error("Please attach a file before clicking upload!") if file_missing?
    return handle_error("Please upload a valid CSV file") unless valid_csv_file?

    begin
      result = CloudinaryFileUploadService.call(file: params[:file])
      if result.success?
        render(json: { success: true, message: "Upload in progress!" }, status: :ok)
      else
        handle_error("Something went wrong with upload!")
      end
    rescue StandardError => e
      handle_error("Something went wrong, #{e.message}")
    end
  end

  private

  def file_missing?
    params[:file].blank?
  end

  def valid_csv_file?
    params[:file].content_type == "text/csv"
  end

  def handle_error(message)
    respond_to do |format|
      format.html { redirect_to(users_path, alert: message, status: :unprocessable_entity) }
      format.json { render(json: { success: false, error: message }, status: :unprocessable_entity) }
    end
  end
end
