# frozen_string_literal: true

# User model handles user data and validates the presence and strength of passwords.
class User < ApplicationRecord
  validates :name, presence: true
  validates :password, presence: true, length: { in: 10..16 }
  validate :strong_password, unless: -> { password.blank? }

  private

  def strong_password
    check_lowercase
    check_uppercase
    check_digit
    check_repeating_characters
  end

  def check_lowercase
    return unless password.chars.none? { |char| ("a".."z").include?(char) }

    errors.add(:password, "must contain at least one lowercase letter")
  end

  def check_uppercase
    return unless password.chars.none? { |char| ("A".."Z").include?(char) }

    errors.add(:password, "must contain at least one uppercase letter")
  end

  def check_digit
    return unless password.chars.none? { |char| ("0".."9").include?(char) }

    errors.add(:password, "must contain at least one digit")
  end

  def check_repeating_characters
    password.chars.each_cons(3) do |a, b, c|
      if a.casecmp?(b) && b.casecmp?(c)
        errors.add(:password, "cannot contain three repeating characters in a row")
        break
      end
    end
  end  
end
