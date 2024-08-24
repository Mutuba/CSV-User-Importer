# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UsersCsvUploadJob, type: :job) do
  let(:file_path) { "path/to/file.csv" }
  let(:base_url) { "http://example.com" }

  context "with correct params" do
    before do
      allow(UsersCsvImportService).to(receive(:call).and_return(true))
    end

    it "calls UsersCsvImportService with correct parameters" do
      expect(UsersCsvImportService).to(receive(:call).with(file_path: Rails.root.join(file_path), base_url: base_url))
      UsersCsvUploadJob.perform_now(string_file_path: file_path, base_url: base_url)
    end
  end

  context "sidekiq options" do
    it "queues on the right queue" do
      expect(UsersCsvUploadJob.queue_name).to(eq("users_csv_upload"))
    end

    it "has the correct timeout and retry options" do
      expect(UsersCsvUploadJob.get_sidekiq_options["timeout"]).to(eq(300))
      expect(UsersCsvUploadJob.get_sidekiq_options["retry"]).to(eq(5))
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
        UsersCsvUploadJob.perform_now(string_file_path: file_path, base_url: base_url)
      end.to(raise_error(StandardError, "Test error"))
    end
  end

  context "#perform_later" do
    before do
      allow(UsersCsvImportService).to(receive(:call).and_return(true))
    end

    it "uploads URLs by enqueuing job" do
      expect do
        UsersCsvUploadJob.perform_later(
          string_file_path: file_path,
          base_url: base_url
        )
      end.to(change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1))

      perform_enqueued_jobs(only: UsersCsvUploadJob)

      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to(eq(0))
    end
  end
end
