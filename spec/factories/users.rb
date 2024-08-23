# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Internet.name }
    password { Faker::Internet.password(min_length: 10, max_length: 16, mix_case: true, special_characters: true) }
  end
end
