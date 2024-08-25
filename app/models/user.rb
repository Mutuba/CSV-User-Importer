# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true
  validates :password, presence: true, length: { in: 10..16 }
  validates_with StrongPasswordValidator
end
