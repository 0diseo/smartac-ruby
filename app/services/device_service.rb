# frozen_string_literal: true

require_relative '../adapters/device_model_adapter'
require_relative '../adapters/reading_model_adapter'
module DeviceService
  def self.device
    @device ||= DeviceModelAdapter.new
  end

  def self.device=(device)
    @device = device
  end

  def self.reading
    @reading ||= ReadingModelAdapter.new
  end

  def self.reading=(reading)
    @reading = reading
  end

  def self.create_device(params)
    device.create(params)
  end

  def self.validate_token_registration(serial_number, token)
    valid_token = serial_number.present? ? serial_number + serial_number.reverse : nil
    valid_token.present? and token == valid_token
  end

  def self.find_device_by_token(token)
    device.find_by_token(token)
  end

  def self.char_average_readings(device, param)
    reading.order_by_day_average(device.readings, param)
  end
end
