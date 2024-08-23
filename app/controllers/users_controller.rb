require 'csv'
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    if file_missing?
      redirect_to users_path, alert: "Please upload a file"
    elsif !valid_csv_file?
      redirect_to users_path, alert: "Please upload a valid CSV file"
    else
      process_csv_file(params[:file])
      redirect_to users_path, notice: "CSV upload completed"
    end
  end
  
  private
  
  def valid_csv_file?
    params[:file].content_type == 'text/csv'
  end
  
  def process_csv_file(file)
    CSV.foreach(file.path, headers: true) do |row|
      next if row['name'].blank? && row['password'].blank?
      user = User.new(name: row['name'], password: row['password'])
      flash.now[:error] ||= []
      flash.now[:error] << "Error in row: #{row.inspect} - #{user.errors.full_messages.join(', ')}" unless user.save
    end
  end
  
  def file_missing?
    params[:file].blank?
  end
end
