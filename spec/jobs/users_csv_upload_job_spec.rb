# frozen_string_literal: true

require "rails_helper"
require "webmock/rspec"

RSpec.describe(UsersCsvUploadJob, type: :job) do
  let(:base_url) { "http://example.com/file.csv" }
  let(:file_content) { "sample file content" }
  let(:temp_file_path) { "dummy_tempfile_path" }

  before do
    stub_request(:get, base_url).to_return(body: file_content)

    @temp_file = instance_double("Tempfile", path: temp_file_path)
    allow(Tempfile).to(receive(:new).and_return(@temp_file))
    allow(@temp_file).to(receive(:close))
    allow(@temp_file).to(receive(:unlink))
  end

  context "with correct params" do
    before do
      allow(UsersCsvImportService).to(receive(:call))
    end

    it "downloads the file and calls UsersCsvImportService with correct parameters" do
      expect(UsersCsvImportService).to(receive(:call).with(file_path: temp_file_path))

      UsersCsvUploadJob.perform_now(string_file_path: base_url)

      expect(@temp_file).to(have_received(:close))
      expect(@temp_file).to(have_received(:unlink))
    end
  end

  context "error handling" do
    before do
      allow(UsersCsvImportService).to(receive(:call).and_raise(StandardError, "Test error"))
      @logger = instance_double("ActiveSupport::Logger")
      allow(Rails).to(receive(:logger).and_return(@logger))
      allow(@logger).to(receive(:error))
    end

    it "logs errors and raises exceptions on failure" do
      expect(@logger).to(receive(:error).with(/An error occurred: Test error/))

      expect do
        UsersCsvUploadJob.perform_now(string_file_path: base_url)
      end.to(raise_error(StandardError, "Test error"))
    end
  end

  context "file cleanup" do
    it "closes and deletes the temporary file after execution" do
      temp_file = instance_double("Tempfile", path: temp_file_path)
      allow(temp_file).to(receive(:close))
      allow(temp_file).to(receive(:unlink))
      allow(Tempfile).to(receive(:new).and_return(temp_file))

      UsersCsvUploadJob.perform_now(string_file_path: base_url)

      expect(temp_file).to(have_received(:close))
      expect(temp_file).to(have_received(:unlink))
    end
  end

  context "sidekiq options" do
    it "queues on the correct queue" do
      expect(UsersCsvUploadJob.queue_name).to(eq("users_csv_upload"))
    end

    it "has the correct timeout and retry options" do
      expect(UsersCsvUploadJob.get_sidekiq_options["timeout"]).to(eq(300000))
      expect(UsersCsvUploadJob.get_sidekiq_options["retry"]).to(eq(5))
    end
  end
end
