# spec/factories.rb
FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "User #{i}" }
    sequence(:email) { |i| "user#{i}@example.com" }
    sequence(:password) { |i| "AAaa11!!" }
  end
end