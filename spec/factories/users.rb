# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::DcComics.name }
    email { Faker::Internet.email }
    password { "Password1!" }
  end
end
