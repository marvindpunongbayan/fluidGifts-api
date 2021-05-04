# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::DcComics.name }
    email { Faker::Internet.email }
    password { "Password1!" }

    factory :admin do
      role { :admin }
    end

    factory :vendor do
      role { :vendor }
    end
  end
end
