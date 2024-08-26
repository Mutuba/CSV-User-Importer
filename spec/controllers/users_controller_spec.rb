# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UsersController, type: :controller) do
  before { allow(CsvFileUploadService).to(receive(:call).and_return(double(success?: true))) }
  describe "#create" do
    it "creates users from a valid CSV file" do
      file = fixture_file_upload("users.csv", "text/csv")
      post :create, params: { file: file }

      expect(JSON.parse(response.body)["message"]).to(eq("Upload in progress!"))
    end

    it "does not create users from an invalid CSV file" do
      file = fixture_file_upload("invalid_users.csv", "text/csv")
      post :create, params: { file: file }
      perform_enqueued_jobs(only: UsersCsvUploadJob)
      expect(User.count).to(eq(0))
    end

    it "sets an alert if no file is uploaded" do
      post :create
      expect(flash[:alert]).to(eq("Please attach a file before clicking upload!"))
    end

    it "sets an alert if an invalid file type is uploaded" do
      file = fixture_file_upload("users.txt", "text/plain")
      post :create, params: { file: file }
      expect(flash[:alert]).to(eq("Please upload a valid CSV file"))
    end
  end

  describe "#index" do
    let!(:users) { create_list(:user, 4) }

    it "returns all users" do
      get :index

      expect(response).to(have_http_status(:ok))
      expect(assigns(:users).count).to(eq(users.count))
      expect(assigns(:users)).to(match_array(users))
    end
  end
end
