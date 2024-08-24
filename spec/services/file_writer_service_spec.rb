# frozen_string_literal: true

require "rails_helper"
require "securerandom"

RSpec.describe(FileWriterService, type: :service) do
  let(:base_url) { Faker::Internet.url }
  let(:file_content) { "sample content" }
  let(:file) { instance_double("Tempfile", read: file_content) }
  let(:file_path) { Rails.root.join("public", "user-import-dummy-uuid.csv").to_path }
  let(:file_writer_service) do
    described_class.call(
      file:,
      base_url:,
    )
  end

  before do
    allow(SecureRandom).to(receive(:uuid).and_return("dummy-uuid"))
  end

  after do
    clear_enqueued_jobs
  end

  describe "#call" do
    context "when the file is written successfully" do
      it "writes the file to disk" do
        described_class.call(file: file, base_url: base_url)
        expect(File).to(exist(file_path))
        expect(File.read(file_path)).to(eq(file_content))
      end

      it "enqueues the UserCsvUploadJob with correct arguments" do
        expect do
          file_writer_service
        end.to(have_enqueued_job(UsersCsvUploadJob).with(
          string_file_path: file_path,
          base_url: base_url,
        ))
        perform_enqueued_jobs
        assert_performed_jobs 1
        expect { file_writer_service }.not_to(raise_error)
      end
    end

    context "when an Errno::EACCES error is raised" do
      before do
        allow(File).to(receive(:write).and_raise(Errno::EACCES.new("Permission denied")))
      end

      it "logs the error and raises it" do
        expect { file_writer_service }.to(raise_error(Errno::EACCES))
      end
    end

    context "when an Errno::ENOENT error is raised" do
      before do
        allow(File).to(receive(:write).and_raise(Errno::ENOENT.new("File not found")))
      end

      it "logs the error and raises it" do
        expect { file_writer_service }.to(raise_error(Errno::ENOENT))
      end
    end

    context "when an Errno::ENOSPC error is raised" do
      before do
        allow(File).to(receive(:write).and_raise(Errno::ENOSPC.new("Disk full")))
      end

      it "logs the error and raises it" do
        expect { file_writer_service }.to(raise_error(Errno::ENOSPC))
      end
    end

    context "when an Encoding::UndefinedConversionError is raised" do
      before do
        allow(File).to(receive(:write).and_raise(Encoding::UndefinedConversionError.new("Encoding error")))
      end

      it "logs the error and raises it" do
        expect { file_writer_service }.to(raise_error(Encoding::UndefinedConversionError))
      end
    end

    context "when an Encoding::InvalidByteSequenceError is raised" do
      before do
        allow(File).to(receive(:write).and_raise(Encoding::InvalidByteSequenceError.new("Encoding error")))
      end

      it "logs the error and raises it" do
        expect { file_writer_service }.to(raise_error(Encoding::InvalidByteSequenceError))
      end
    end

    context "when a StandardError is raised" do
      before do
        allow(File).to(receive(:write).and_raise(StandardError.new("IO error")))
      end

      it "logs the error and raises it" do
        expect { file_writer_service }.to(raise_error(StandardError))
      end
    end
  end
end
