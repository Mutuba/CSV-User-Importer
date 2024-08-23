# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with valid name and password' do
    let(:user) { build(:user) }
    it 'is valid' do
      expect(user).to be_valid
    end
  end

  context 'when name is nil' do
    let(:user) { build(:user, name: nil) }

    it 'is invalid' do
      expect(user).not_to be_valid
    end
  end

  context 'when password is nil' do
    let(:user) { build(:user, password: nil) }

    it 'is invalid' do
      expect(user).not_to be_valid
    end
  end

  # it "is invalid with a weak password" do
  #   user = User.new(name: "John Doe", password: "Abc123")
  #   expect(user).not_to be_valid
  # end

  # it "is invalid with a password that has three repeating characters" do
  #   user = User.new(name: "John Doe", password: "AAAfk1swods")
  #   expect(user).not_to be_valid
  # end
end
