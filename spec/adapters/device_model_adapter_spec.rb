# frozen_string_literal: true

require 'rails_helper'
require 'json_web_token'
require_relative '../../app/adapters/device_model_adapter'

RSpec.describe DeviceModelAdapter, type: :model do
  describe 'create a Device' do
    let(:valid_params) { { serial_number: 'abc123', firmware_version: 'v1.2' } }
    let(:device) { described_class.new.create(valid_params) }

    specify { expect(device.class.name).to eq('Device') }
    specify { expect(device.serial_number).to eq('abc123') }
    specify { expect(device.firmware_version).to eq('v1.2') }
  end

  describe 'find_by_token' do
    let(:device) { create(:device) }
    let(:token) { JsonWebToken.encode({ id: device.id }) }

    it 'return a device with a valid token' do
      device_token = described_class.new.find_by_token(token)
      expect(device_token).to eq(device)
    end

    it 'return nil with invalid token' do
      device_token = described_class.new.find_by_token('invalid')
      expect(device_token).to eq(nil)
    end
  end
end
