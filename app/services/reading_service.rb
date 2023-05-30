# frozen_string_literal: true

require_relative '../adapters/device_model_adapter'
require_relative '../adapters/reading_model_adapter'

module ReadingService
  attr_reader :device, :reading

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

  def self.save_readings(arr_params, device)
    readings = arr_params.map { |params| reading.create(reformat_params(params, device)) }.each(&:valid?)
    invalids = readings.select { |validate| validate.errors.present? }
    if invalids.present?
      invalids
    else
      readings
    end
  end

  def self.get_device_from_token(token)
    device.find_by_token(token)
  end

  def self.reformat_params(params, device)
    params[:recorded_at] = params.delete :timestamp
    params[:device_id] = device.id
    params
  end
end
