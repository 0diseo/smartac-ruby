# frozen_string_literal: true

require_relative '../../../services/reading_service'
class Api::V1::ReadingsController < Api::V1::ApiController
  before_action :validate_jwt
  def update
    device = device_by_token
    readings = ReadingService.save_readings(reading_params, device)
    if readings.select { |read| read.errors.present? }.empty?
      render json: '', nothing: true, status: 204
    else
      render json: readings.map { |read| { timestamp: read.recorded_at, error: read.errors } }, status: 422
    end
  end

  private

  def reading_params
    params.require(:readings).map do |p|
      p.permit(:temperature, :humidity, :co_level, :health, :timestamp)
    end
  end

  def validate_jwt
    device = ReadingService.get_device_from_token(auth_header)
    render json: { error: 'Invalid jwt' }, status: :unauthorized if device.nil?
  end

  def device_by_token
    ReadingService.get_device_from_token(auth_header)
  end
end
