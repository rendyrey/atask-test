# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
