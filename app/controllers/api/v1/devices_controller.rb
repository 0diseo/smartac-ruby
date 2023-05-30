# frozen_string_literal: true

require 'json_web_token'
require_relative '../../../services/device_service'
class Api::V1::DevicesController < Api::V1::ApiController
  before_action :validate_registration, only: [:create]

  def create
    @device = DeviceService.create_device(device_params)
    if @device.valid?
      token = JsonWebToken.encode({ id: @device.id })
      render json: { device: @device, token: token }
    else
      render json: @device.errors, status: 422
    end
  end

  def show
    device = DeviceService.find_device_by_token(auth_header)
    if device&.id == params[:id].to_i
      render json: { token_valid: true }
    else
      render json: { token_valid: false }, status: 422
    end
  end

  private

  def device_params
    params.require(:device).permit(:serial_number, :firmware_version)
  end

  def validate_registration
    valid_token = DeviceService.validate_token_registration(device_params[:serial_number], auth_header)
    render json: { error: 'Invalid Device Key' }, status: :unauthorized unless valid_token
  end
end
