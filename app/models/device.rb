# frozen_string_literal: true

class Device < ApplicationRecord
  has_many :readings, dependent: :destroy
  validates :serial_number, presence: true
  validates :firmware_version, presence: true

  before_save :validate_serial_number

  def validate_serial_number
    raise ArgumentError, 'Serial number is required' if serial_number.nil?
  end
end
