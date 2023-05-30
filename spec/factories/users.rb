# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Joe' }
    last_name { 'User' }
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password { '123456' }
  end
end
