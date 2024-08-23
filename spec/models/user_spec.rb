# frozen_string_literal: true

require "rails_helper"

RSpec.describe(User, type: :model) do
  describe "Database Schema" do
    context "column validations" do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:password).of_type(:string) }
    end
  end

  describe "Validations" do
    context "with valid attributes" do
      let(:user) { build(:user) }

      it "is valid with valid attributes" do
        expect(user).to(be_valid)
        expect(user.errors.full_messages).to(be_empty)
      end
    end

    context "when name is nil" do
      let(:user) { build(:user, name: nil) }

      it "is invalid" do
        expect(user).not_to(be_valid)
        expect(user.errors.full_messages).to(include("Name can't be blank"))
      end
    end

    context "when password is nil" do
      let(:user) { build(:user, password: nil) }

      it "is invalid" do
        expect(user).not_to(be_valid)
        expect(user.errors.full_messages).to(include(
          "Password can't be blank",
          "Password is too short (minimum is 10 characters)",
        ))
      end
    end

    context "with a weak password" do
      let(:user) { build(:user, password: "Abc123") }

      it "is invalid" do
        expect(user).not_to(be_valid)
        expect(user.errors.full_messages).to(include("Password is too short (minimum is 10 characters)"))
      end
    end

    context "with three repeating characters in password" do
      let(:user) { build(:user, password: "AAAfk1swods") }

      it "is invalid" do
        expect(user).not_to(be_valid)
        expect(user.errors.full_messages).to(include("Password cannot contain three repeating characters in a row"))
      end
    end
  end
end
