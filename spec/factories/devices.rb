# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    sequence :serial_number do |n|
      "abc1#{n}"
    end
    firmware_version { 'v1.0.0' }
  end
end
