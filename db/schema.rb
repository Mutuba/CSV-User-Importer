# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_823_113_954) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'users', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'password', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    # Prevent three repeating characters in a row
    t.check_constraint \
      "NOT password::text ~ '(.)\\1\\1'::text",
      name: 'password_no_repeating_characters_check'

    # Ensure the password length is between 10 and 16 characters
    t.check_constraint \
      'char_length(password::text) >= 10 AND char_length(password::text) <= 16',
      name: 'password_length_check'

    # Ensure the password contains at least one lowercase letter, one uppercase letter, and one digit
    t.check_constraint \
      "password::text ~ '[a-z]'::text AND password::text ~ '[A-Z]'::text AND password::text ~ '[0-9]'::text",
      name: 'password_complexity_check'
  end
end
