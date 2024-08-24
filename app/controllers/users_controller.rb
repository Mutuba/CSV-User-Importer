# frozen_string_literal: true

require "csv"

class UsersController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.html 
      format.json { render(json: @users) }
    end
  end

  def create
    if file_missing?
      handle_error("Please upload a file")
    elsif !valid_csv_file?
      handle_error("Please upload a valid CSV file")
    else
      process_csv_file(params[:file])
      respond_to do |format|
        format.html { redirect_to(users_path, notice: "CSV upload completed") }
        format.json { render(json: { success: true }, status: :created) }
      end
    end
  end

  private

  def file_missing?
    params[:file].blank?
  end

  def valid_csv_file?
    params[:file].content_type == "text/csv"
  end

  def process_csv_file(file)
    CSV.foreach(file.path, headers: true) do |row|
      next if row["name"].blank? && row["password"].blank?

      user = User.new(name: row["name"], password: row["password"])
      unless user.save
        flash.now[:error] ||= []
        flash.now[:error] << "Error in row: #{row.inspect} - #{user.errors.full_messages.join(", ")}"
      end
    end
  end

  def handle_error(message)
    respond_to do |format|
      format.html { redirect_to(users_path, alert: message) }
      format.json { render(json: { success: false, error: message }, status: :unprocessable_entity) }
    end
  end
end
