# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UsersController, type: :controller) do
  describe "#create" do
    context "with a valid CSV file", vcr: true do
      # it "enqueues the UsersCsvUploadJob and returns a success message", vcr: true do
      #   file = fixture_file_upload("users.csv", "text/csv")

      #   post(:create, params: { file: file })

      #   perform_enqueued_jobs(only: UsersCsvUploadJob)
      #   expect(JSON.parse(response.body)["message"]).to(eq("Upload in progress!"))
      # end
      it "enqueues the UsersCsvUploadJob and returns a success message" do
        file = fixture_file_upload("users.csv", "text/csv")
        post(:create, params: { file: file })
        puts "Upload in progress, #{JSON.parse(response.body)}"
        expect(response).to(have_http_status(:ok))
        expect(JSON.parse(response.body)["message"]).to(eq("Upload in progress!"))
        expect(UsersCsvUploadJob).to(have_been_enqueued)
      end
    end

    context "when no file is uploaded" do
      it "sets an alert asking for a file upload" do
        post :create

        expect(flash[:alert]).to(eq("Please attach a file before clicking upload!"))
      end
    end

    context "with an invalid file type" do
      it "sets an alert asking for a valid CSV file" do
        file = fixture_file_upload("users.txt", "text/plain")

        post :create, params: { file: file }

        expect(flash[:alert]).to(eq("Please upload a valid CSV file"))
      end
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
