# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UsersController, type: :controller) do
  describe "#create" do
    it "creates users from a valid CSV file" do
      file = fixture_file_upload("users.csv", "text/csv")
      post :create, params: { file: file }
      expect(User.count).to(eq(1))
      expect(flash[:notice]).to(eq("CSV upload completed"))
    end

    it "does not create users from an invalid CSV file" do
      file = fixture_file_upload("invalid_users.csv", "text/csv")
      post :create, params: { file: file }
      expect(User.count).to(eq(0))
      error_messages = flash.now[:error]
      expect(error_messages).to(include(a_string_including("Error in row")))
    end

    it "sets an alert if no file is uploaded" do
      post :create
      expect(flash[:alert]).to(eq("Please upload a file"))
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
      expect(assigns(:users).count).to eq(users.count)
      expect(assigns(:users)).to match_array(users)
    end
  end
end
