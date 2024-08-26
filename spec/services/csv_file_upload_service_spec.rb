# frozen_string_literal: true

require "rails_helper"

RSpec.describe(CsvFileUploadService, type: :service) do
  let(:file_path) { Rails.root.join("spec", "fixtures", "files", "users.csv") }
  let(:file) do
    Tempfile.new(["test_users", ".csv"]).tap do |f|
      f.write(File.read(file_path))
      f.rewind
    end
  end
  let(:cloudinary_response) do
    {
      "url" => "http://res.cloudinary.com/dsrvrjdsl/raw/upload/v1724641396/test_users.csv",
      "public_id" => "test_users20240826-38804-630k7a",
    }
  end

  before do
    allow(Cloudinary::Uploader).to(receive(:upload).and_return(cloudinary_response))
  end

  let(:service) { described_class.call(file: file) }

  after do
    file.close
    file.unlink
  end

  context "when the file upload is successful" do
    it "uploads the file to Cloudinary and enqueues a job", :vcr do
      service

      expect(UsersCsvUploadJob).to(have_been_enqueued.with(
        string_file_path: cloudinary_response["url"],
      ))
    end

    it "returns a success result with the correct attributes" do
      result = service
      expect(result).to(be_a(CsvFileUploadService::SuccessStruct))
      expect(result.file_url).to(eq(cloudinary_response["url"]))
      expect(result.public_id).to(eq(cloudinary_response["public_id"]))
    end
  end

  context "when the file upload fails due to a CloudinaryException" do
    before do
      allow(Cloudinary::Uploader).to(receive(:upload).and_raise(CloudinaryException.new("Some error occurred")))
    end

    it "returns a failure result with the correct error message" do
      result = described_class.call(file: file)
      expect(result).to(be_a(CsvFileUploadService::FailureStruct))
      expect(result.error).to(eq("Some error occurred"))
    end

    it "does not enqueue a job" do
      expect(UsersCsvUploadJob).not_to(have_been_enqueued)
    end
  end

  context "when an unexpected error occurs during file upload" do
    before do
      allow(Cloudinary::Uploader).to(receive(:upload).and_raise(StandardError.new("Unexpected error")))
    end

    it "returns a failure result with the correct error message" do
      result = described_class.call(file: file)
      expect(result).to(be_a(CsvFileUploadService::FailureStruct))
      expect(result.error).to(eq("Unexpected error"))
    end

    it "does not enqueue a job" do
      expect(UsersCsvUploadJob).not_to(have_been_enqueued)
    end
  end
end
