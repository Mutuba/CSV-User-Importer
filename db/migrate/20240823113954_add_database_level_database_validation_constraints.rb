# frozen_string_literal: true

# AddDatabaseLevelDatabaseValidationConstraints adds constraints to the users table
# to enforce password length and complexity at the database level.
class AddDatabaseLevelDatabaseValidationConstraints < ActiveRecord::Migration[7.1]
  def change
    # Length constraint: Ensures the password length is between 10 and 16 characters.
    add_check_constraint :users,
                         'char_length(password) BETWEEN 10 AND 16',
                         name: 'password_length_check'

    # Complexity constraint: Ensures the password contains at least one lowercase letter,
    # one uppercase letter, and one digit.
    add_check_constraint :users,
                         "password ~ '[a-z]' AND password ~ '[A-Z]' AND password ~ '[0-9]'",
                         name: 'password_complexity_check'

    # Repeating characters constraint: Prevents passwords from containing three consecutive
    # repeating characters.
    add_check_constraint :users,
                         "NOT (password ~ '(.)\\1\\1')",
                         name: 'password_no_repeating_characters_check'
  end
end
