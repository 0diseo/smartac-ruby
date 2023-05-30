# frozen_string_literal: true

require_relative '../services/device_service'
class DevicesController < ApplicationController
  private

  helper_method :devices, :device, :chart_average_per_day
  def devices
    @devices ||= Device.all
  end

  def device
    @device ||= Device.includes(:readings).find(params[:id])
  end

  def chart_average_per_day(param)
    DeviceService.char_average_readings(device, param)
  end
end
