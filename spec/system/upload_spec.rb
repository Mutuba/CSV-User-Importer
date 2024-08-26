# frozen_string_literal: true

require "rails_helper"

RSpec.describe("File Uploads", type: :system) do
  it "allows a user to upload a file and see results", js: true, vrr: true do
    Sidekiq::Testing.inline! do
      visit users_path

      click_on "Upload CSV"
      expect(page).to(have_selector("#uploadModal", visible: true))
      expect(page).to(have_selector('input[type="file"]', visible: true))
      within("#uploadModal") do
        attach_file("file", Rails.root.join("spec/fixtures/files/users.csv"))
        click_on "Upload File"
      end
      within("#users_table") do
        expect(page).to(have_text(/Muhammad/, wait: 10))
      end
    end
  end

  it "shows errors when file upload fails", js: true do
    visit users_path

    find("button", text: "Upload CSV").click
    within("#uploadModal") do
      attach_file("file", Rails.root.join("spec/fixtures/files/invalid_users.csv"))
      click_on "Upload File"
    end
    within("#users_error_table") do
      expect(page).to(have_text("Error Log"))
      expect(page).to(have_text("Password cannot contain three repeating characters in a row"))
      expect(page).to(have_text("Password is too short (minimum is 10 characters)"))
    end
  end

  it "shows errors when file is not attached", js: true, vcr: true do
    visit users_path
    click_on "Upload CSV"
    expect(page).to(have_selector("#uploadModal", visible: true))
    within("#uploadModal") do
      click_on "Upload File"
    end
    expect(page).to(have_text("Please attach a file before clicking upload!"))
  end
end
