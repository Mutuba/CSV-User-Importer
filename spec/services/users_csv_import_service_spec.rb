# frozen_string_literal: true

require "rails_helper"
require "csv"

RSpec.describe(UsersCsvImportService, type: :service) do
  let(:base_url) { "http://localhost:3000" }
  let(:file_path) { Rails.root.join("spec/fixtures/files/test_users.csv") }

  before do
    CSV.open(file_path, "wb") do |csv|
      csv << ["name", "password"]
      csv << ["John Doe", "QPFJWz1343439"]
      csv << ["Jane Smith", "QPFJWz1343439"]
    end
  end

  after do
    FileUtils.rm(file_path) if File.exist?(file_path)
  end

  describe "#call" do
    context "when the CSV file is valid" do
      it "processes the CSV and creates users" do
        expect { described_class.call(file_path: file_path, base_url: base_url) }.to(change(User, :count).by(2))

        expect(File.exist?(file_path)).to(be_falsey)
      end
    end

    context "when the file does not exist" do
      let(:fake_file_path) { "fake.csv" }

      it "raises an Errno::ENOENT error" do
        expect do
          described_class.call(file_path: fake_file_path, base_url: base_url)
        end.to(raise_error(Errno::ENOENT))
      end
    end
  end

  describe "broadcasting" do
    before do
      allow(Turbo::StreamsChannel).to(receive(:broadcast_append_to))
    end

    it "broadcasts the upload progress" do
      described_class.call(file_path: file_path, base_url: base_url)
      expect(Turbo::StreamsChannel).to(have_received(:broadcast_append_to).with(
        "upload_progress",
        target: "uploadProgress",
        partial: "users/progress",
        locals: hash_including(:progress),
      ))
    end

    it "broadcasts created users" do
      described_class.call(file_path: file_path, base_url: base_url)
      expect(Turbo::StreamsChannel).to(have_received(:broadcast_append_to).with(
        "users",
        target: "users",
        partial: "users/user",
        locals: hash_including(:user),
      ).twice)
    end
  end
end
